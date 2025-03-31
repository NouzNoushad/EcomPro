package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/google/uuid"
)

// handle request methods (cart)
func (s *APIServer) handleCart(w http.ResponseWriter, r *http.Request) error {
	if r.Method == "POST" {
		return s.handleAddCart(w, r)
	}

	return fmt.Errorf("method not allowed %s", r.Method)
}

// account validation
func cartValidation(cart *Cart) error {

	// name
	if cart.UserID == "" {
		return validationError("user Id is required")
	}

	return nil
}

// handle create cart
func (s *APIServer) handleAddCart(w http.ResponseWriter, r *http.Request) error {
	cart := new(Cart)

	// parse multipart form
	err := r.ParseMultipartForm(10 << 20)
	if err != nil {
		return badRequestError(w, "Failed to parse form")
	}

	cart.ID = uuid.New().String()
	cart.UserID = r.FormValue("user_id")
	cart.TotalCost, err = stringToFloat(r.FormValue("total_cost"))
	if err != nil {
		return badRequestError(w, "Invalid total cost format")
	}
	cart.UpdatedAt = time.Now().UTC().Format(time.RFC3339)
	cart.CreatedAt = time.Now().UTC().Format(time.RFC3339)

	if err := cartValidation(cart); err != nil {
		return badRequestError(w, err.Error())
	}

	cartItemsData := r.MultipartForm.Value["cartItems"]
	cartItems := []*CartItem{}

	if len(cartItemsData) > 0 {
		err := json.Unmarshal([]byte(cartItemsData[0]), &cartItems)
		if err != nil {
			return serverError(w, "failed to parse the json")
		}

		for _, cartItem := range cartItems {
			newCartItem := CartItem{
				ID:         uuid.New().String(),
				CartID:     cart.ID,
				ProductID:  cartItem.ProductID,
				Price:      cartItem.Price,
				Quantity:   cartItem.Quantity,
				TotalPrice: float64(cartItem.Quantity) * cartItem.Price,
				UpdatedAt:  time.Now().UTC().Format(time.RFC3339),
				CreatedAt:  time.Now().UTC().Format(time.RFC3339),
			}

			cartItems = append(cartItems, &newCartItem)
		}
	}

	cart.Items = cartItems

	// store
	if err := s.store.CreateCart(cart, cartItems); err != nil {
		return serverError(w, err.Error())
	}

	// success
	return WriteJSON(w, http.StatusCreated, map[string]interface{}{
		"message": "Added to Cart",
		"data":    cart,
	})
}
