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

	if r.Method == "GET" {
		return s.handleGetCarts(w, r)
	}

	return fmt.Errorf("method not allowed %s", r.Method)
}

// handle request methods (cart by id)
func (s *APIServer) handleCartByID(w http.ResponseWriter, r *http.Request) error {

	if r.Method == "GET" {
		return s.handleGetCartByID(w, r)
	}

	if r.Method == "DELETE" {
		return s.handleDeleteCart(w, r)
	}

	return fmt.Errorf("method not allowed %s", r.Method)
}

// handle request method (cart item)
func (s *APIServer) handleCartItem(w http.ResponseWriter, r *http.Request) error {
	if r.Method == "POST" {
		return s.handleAddCartItem(w, r)
	}

	return fmt.Errorf("method not allowed %s", r.Method)
}

// handle get carts
func (s *APIServer) handleGetCarts(w http.ResponseWriter, _ *http.Request) error {
	carts, err := s.store.GetCarts()
	if err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, map[string]interface{}{
		"data":  carts,
		"items": fmt.Sprintf("%d items", len(carts)),
	})
}

// cart validation
func cartValidation(cart *Cart) error {

	// user id
	if cart.UserID == "" {
		return validationError("User Id is required")
	}

	return nil
}

// cart item validation
func cartItemValidation(cartItem *CartItem) error {

	// cart id
	if cartItem.CartID == "" {
		return validationError("Cart Id is required")
	}

	// product id
	if cartItem.ProductID == "" {
		return validationError("Product Id is required")
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

// handle cart by id
func (s *APIServer) handleGetCartByID(w http.ResponseWriter, r *http.Request) error {
	id := getID(r)

	cart, err := s.store.GetCartByID(id)
	if err != nil {
		return err
	}

	// success
	return WriteJSON(w, http.StatusOK, map[string]interface{}{
		"data": cart,
	})
}

// handle delete cart
func (s *APIServer) handleDeleteCart(w http.ResponseWriter, r *http.Request) error {
	id := getID(r)

	if err := s.store.DeleteCart(id); err != nil {
		return err
	}

	// success
	return WriteJSON(w, http.StatusOK, map[string]interface{}{
		"message": fmt.Sprintf("Cart with id [%s] is deleted", id),
		"id":      id,
	})
}

// handle create cart item
func (s *APIServer) handleAddCartItem(w http.ResponseWriter, r *http.Request) error {
	cartItem := new(CartItem)

	// parse multipart form
	err := r.ParseMultipartForm(10 << 20)
	if err != nil {
		return badRequestError(w, "Failed to parse form")
	}

	cartItem.ID = uuid.New().String()
	cartItem.CartID = r.FormValue("cart_id")
	cartItem.ProductID = r.FormValue("product_id")
	cartItem.Price, err = stringToFloat(r.FormValue("price"))
	if err != nil {
		return badRequestError(w, "Invalid price format")
	}
	cartItem.Quantity, err = stringToInt(r.FormValue("quantity"))
	if err != nil {
		return badRequestError(w, "Invalid quantity format")
	}
	cartItem.UpdatedAt = time.Now().UTC().Format(time.RFC3339)
	cartItem.CreatedAt = time.Now().UTC().Format(time.RFC3339)

	cartItem.TotalPrice = float64(cartItem.Quantity) * cartItem.Price

	if err := cartItemValidation(cartItem); err != nil {
		return badRequestError(w, err.Error())
	}

	// store
	if err := s.store.CreateCartItem(cartItem); err != nil {
		return serverError(w, err.Error())
	}

	// success
	return WriteJSON(w, http.StatusCreated, map[string]interface{}{
		"message": "Cart item created",
		"data":    cartItem,
	})
}
