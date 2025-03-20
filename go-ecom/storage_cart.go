package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
)

// Set up cart table
func (s *PostgresStore) createCartTable() error {
	query := `create table if not exists carts (
		id text primary key,
		user_id text not null,
		total_cost numeric(10, 2) default 0.00,
		updated_at timestamp default now(),
		created_at timestamp default now()
	)`

	_, err := s.db.Exec(query)

	return err
}

// Set up cart item table
func (s *PostgresStore) createCartItemTable() error {
	query := `create table if not exists cartItems (
		id text primary key,
		cart_id text not null,
		product_id text not null,
		price numeric(10, 2) default 0.00,
		quantity numeric(10, 2) default 0.00,
		total_price numeric(10, 2) default 0.00,
		updated_at timestamp default now(),
		created_at timestamp default now()
	)`

	_, err := s.db.Exec(query)

	return err
}

// create cart
func (s *PostgresStore) CreateCart(cart *Cart, cartItems []*CartItem) error {
	// begin new transaction
	tx, err := s.db.Begin()
	if err != nil {
		return err
	}

	// insert cart
	query := `insert into carts(
		id,
		user_id,
		total_cost,
		updated_at,
		created_at) values ($1, $2, $3, $4, $5)`

	_, err = tx.Exec(
		query,
		cart.ID,
		cart.UserID,
		cart.TotalCost,
		cart.UpdatedAt,
		cart.CreatedAt,
	)

	if err != nil {
		tx.Rollback()
		return fmt.Errorf("failed to insert cart: %v", err)
	}

	// insert cartitem
	if len(cartItems) > 0 {
		cartItem := `insert into cartItems (
			id,
			cart_id,
			product_id,
			price,
			quantity,
			total_price,
			updated_at,
			created_at) values ($1, $2, $3, $4, $5, $6, $7, $8)`

		stmt, err := tx.Prepare(cartItem)
		if err != nil {
			tx.Rollback()
			return fmt.Errorf("failed to prepare cart item: %v", err)
		}
		defer stmt.Close()

		for _, cartItem := range cartItems {
			_, err := stmt.Exec(
				cartItem.ID,
				cartItem.CartID,
				cartItem.ProductID,
				cartItem.Price,
				cartItem.Quantity,
				cartItem.TotalPrice,
				cartItem.UpdatedAt,
				cartItem.CreatedAt,
			)
			if err != nil {
				tx.Rollback()
				return fmt.Errorf("failed to insert item: %v", err)
			}
		}
	}

	// commit transaction
	if err := tx.Commit(); err != nil {
		return fmt.Errorf("failed to commit transaction: %v", err)
	}

	return nil
}

// delete cart
func (s *PostgresStore) DeleteCart(id string) error {
	query := "delete from carts where id = $1"
	_, err := s.db.Query(query, id)

	return err
}

// get carts
func (s *PostgresStore) GetCarts() ([]*Cart, error) {
	query := `
		select
			c.id,
			c.user_id,
			c.total_cost,
			to_char(c.updated_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') as updated_at,
			to_char(c.created_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') as created_at,

			coalesce(jsonb_agg(distinct jsonb_build_object(
				'id', ci.id,
				'cart_id', ci.cart_id,
				'product_id', ci.product_id,
				'price', ci.price,
				'quantity', ci.quantity,
				'total_price', ci.total_price,
				'updated_at', to_char(ci.updated_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"'),
				'created_at', to_char(ci.created_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"')
			)) filter (where ci.id is not null), '[]'::jsonb) as cartItems
		
		from carts c
		left join cartItems ci on c.id = ci.cart_id
		group by c.id
		order by created_at desc
	`

	rows, err := s.db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	carts := []*Cart{}

	for rows.Next() {
		cart, cartItemJson, updatedAtString, createdAtString, err := scanIntoCarts(rows)
		if err != nil {
			return nil, err
		}

		// parse created_at
		cart.CreatedAt, err = parseTime(createdAtString)
		if err != nil {
			return nil, err
		}

		// parse updated_at
		cart.UpdatedAt, err = parseTime(updatedAtString)
		if err != nil {
			return nil, err
		}

		// unmarshal cart item
		if err := json.Unmarshal(cartItemJson, &cart.Items); err != nil {
			return nil, err
		}

		carts = append(carts, cart)
	}

	return carts, nil
}

func (s *PostgresStore) cartRow(query string, id string) (*Cart, error) {
	row := s.db.QueryRow(query, id)

	cart, cartItemJson, updatedAtString, createdAtString, err := scanIntoCarts(row)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("cart with id [%s] not found", id)
		}
	}

	// parse created_at
	cart.CreatedAt, err = parseTime(createdAtString)
	if err != nil {
		return nil, err
	}

	// parse updated_at
	cart.UpdatedAt, err = parseTime(updatedAtString)
	if err != nil {
		return nil, err
	}

	// unmarshal cart item
	if err := json.Unmarshal(cartItemJson, &cart.Items); err != nil {
		return nil, err
	}

	return cart, nil
}

// get cart by id
func (s *PostgresStore) GetCartByID(id string) (*Cart, error) {
	query := `
		select
			c.id,
			c.user_id,
			c.total_cost,
			to_char(c.updated_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') as updated_at,
			to_char(c.created_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') as created_at,

			coalesce(jsonb_agg(distinct jsonb_build_object(
				'id', ci.id,
				'cart_id', ci.cart_id,
				'product_id', ci.product_id,
				'price', ci.price,
				'quantity', ci.quantity,
				'total_price', ci.total_price,
				'updated_at', to_char(ci.updated_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"'),
				'created_at', to_char(ci.created_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"')
			)) filter (where ci.id is not null), '[]'::jsonb) as cartItems
		
		from carts c
		left join cartItems ci on c.id = ci.cart_id
		where c.id = $1
		group by c.id
	`

	cart, err := s.cartRow(query, id)
	if err != nil {
		return nil, err
	}

	return cart, nil
}

func scanIntoCarts(scanner scannable) (*Cart, []byte, string, string, error) {
	cart := new(Cart)
	var cartItemJson []byte
	var updatedAtString, createdAtString string

	err := scanner.Scan(
		&cart.ID,
		&cart.UserID,
		&cart.TotalCost,
		&updatedAtString,
		&createdAtString,
		&cartItemJson,
	)

	return cart, cartItemJson, updatedAtString, createdAtString, err
}

// create cart item
func (s *PostgresStore) CreateCartItem(cartItem *CartItem) error {
	query := `insert into cartItems (
			id,
			cart_id,
			product_id,
			price,
			quantity,
			total_price,
			updated_at,
			created_at) values ($1, $2, $3, $4, $5, $6, $7, $8)`

	_, err := s.db.Query(
		query,
		cartItem.ID,
		cartItem.CartID,
		cartItem.ProductID,
		cartItem.Price,
		cartItem.Quantity,
		cartItem.TotalPrice,
		cartItem.UpdatedAt,
		cartItem.CreatedAt,
	)

	return err
}

// delete cart item
func (s *PostgresStore) DeleteCartItem(id string) error {
	query := "delete from cartItems where id = $1"
	_, err := s.db.Query(query, id)

	return err
}

// get cart item
func (s *PostgresStore) GetCartItems() ([]*CartItem, error) {
	query := "select * from cartItems"
	rows, err := s.db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	cartItems := []*CartItem{}
	for rows.Next() {
		cartItem, updatedAtString, createdAtString, err := scanIntoCartItem(rows)
		if err != nil {
			return nil, err
		}

		// parse created_at
		cartItem.CreatedAt, err = parseTime(createdAtString)
		if err != nil {
			return nil, err
		}

		// parse updated_at
		cartItem.UpdatedAt, err = parseTime(updatedAtString)
		if err != nil {
			return nil, err
		}

		cartItems = append(cartItems, cartItem)
	}

	return cartItems, nil
}

func scanIntoCartItem(scanner scannable) (*CartItem, string, string, error) {
	cartItem := new(CartItem)
	var updatedAtString, createdAtString string

	err := scanner.Scan(
		&cartItem.ID,
		&cartItem.CartID,
		&cartItem.ProductID,
		&cartItem.Price,
		&cartItem.Quantity,
		&cartItem.TotalPrice,
		&updatedAtString,
		&createdAtString,
	)

	return cartItem, updatedAtString, createdAtString, err
}
