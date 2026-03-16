# Data Map: bagisto
_Generated: 2026-03-16 | Language: PHP/Laravel (multi-package Webkul) | Files scanned: ~380_

---

## Entities

### Order
- **Table:** `orders`
- **Store:** MySQL (configured via `DB_DATABASE` in `.env`)
- **Key fields:** `id`, `status` (pending / pending_payment / processing / completed / canceled / closed / fraud), `customer_id`, `customer_first_name`, `customer_last_name`, `is_guest`, `grand_total`, `base_grand_total`, `grand_total_invoiced`, `base_grand_total_invoiced`, `grand_total_refunded`, `base_grand_total_refunded`, `shipping_method`, `cart_id`, `channel_id`, `channel_type`, `created_at`
- **Relationships:** has many `order_items`, `invoices`, `shipments`, `refunds`, `order_transactions`; has one `order_payment`; has many `order_addresses` (billing + shipping); linked to `cart`
- **Confidence:** High
- **Source:** `packages/Webkul/Sales/src/Models/Order.php`

### OrderItem
- **Table:** `order_items`
- **Store:** MySQL
- **Key fields:** `id`, `order_id`, `product_id`, `product_type`, `parent_id`, `type`, `name`, `sku`, `qty_ordered`, `qty_shipped`, `qty_invoiced`, `qty_canceled`, `qty_refunded`, `price`, `base_price`, `total`, `base_total`, `additional` (JSON)
- **Relationships:** belongs to `orders`; has many `invoice_items`, `shipment_items`, `refund_items`
- **Confidence:** High
- **Source:** `packages/Webkul/Sales/src/Models/OrderItem.php`

### OrderPayment
- **Table:** `order_payment`
- **Store:** MySQL
- **Key fields:** `id`, `order_id`, `method`, `additional` (JSON — stores payment gateway data)
- **Confidence:** High
- **Source:** `packages/Webkul/Sales/src/Models/OrderPayment.php`

### OrderTransaction
- **Table:** `order_transactions`
- **Store:** MySQL
- **Key fields:** `id`, `order_id`, `transaction_id`, `payment_method`, `type`, `amount`, `status`, `created_at`
- **Confidence:** High
- **Source:** `packages/Webkul/Sales/src/Models/OrderTransaction.php`

### Invoice
- **Table:** `invoices`
- **Store:** MySQL
- **Key fields:** `id`, `order_id`, `state` (pending / pending_payment / paid / overdue / refunded), `order_address_id`, `grand_total`, `base_grand_total`, `customer_id`, `channel_id`, `created_at`
- **Relationships:** belongs to `orders`; has many `invoice_items`
- **Confidence:** High
- **Source:** `packages/Webkul/Sales/src/Models/Invoice.php`

### Refund
- **Table:** `refunds`
- **Store:** MySQL
- **Key fields:** `id`, `order_id`, `state`, `order_address_id`, `grand_total`, `base_grand_total`, `adjustment_fee`, `base_adjustment_fee`, `customer_id`, `channel_id`, `created_at`
- **Relationships:** belongs to `orders`; has many `refund_items`
- **Confidence:** High
- **Source:** `packages/Webkul/Sales/src/Models/Refund.php`

### Shipment
- **Table:** `shipments`
- **Store:** MySQL
- **Key fields:** `id`, `order_id`, `inventory_source_id`, `order_address_id`, `total_qty`, `carrier_code`, `carrier_title`, `track_number`, `customer_id`, `created_at`
- **Relationships:** belongs to `orders`; has many `shipment_items`; belongs to `inventory_sources`
- **Confidence:** High
- **Source:** `packages/Webkul/Sales/src/Models/Shipment.php`

### Customer
- **Table:** `customers`
- **Store:** MySQL
- **Key fields:** `id`, `first_name`, `last_name`, `gender`, `date_of_birth`, `email`, `phone`, `password` (hidden), `customer_group_id`, `channel_id`, `subscribed_to_news_letter` (bool), `status`, `is_verified`, `is_suspended`, `image`, `token`, `api_token` (hidden), `created_at`
- **Relationships:** belongs to `customer_groups`; has many `addresses`, `orders`, `wishlist_items`, `reviews`, `notes`; has one `subscription`
- **Confidence:** High
- **Source:** `packages/Webkul/Customer/src/Models/Customer.php`

### CustomerAddress
- **Table:** `addresses` (scoped by `address_type = 'customer'`)
- **Store:** MySQL
- **Key fields:** `id`, `customer_id`, `address_type`, `first_name`, `last_name`, `company_name`, `address1`, `address2`, `city`, `state`, `country`, `postcode`, `phone`, `default_address`
- **Note:** Shared `addresses` table is used by customers, orders (billing/shipping), and carts — discriminated by `address_type`
- **Confidence:** High
- **Source:** `packages/Webkul/Customer/src/Models/CustomerAddress.php`, `packages/Webkul/Core/src/Models/Address.php`

### Cart
- **Table:** `cart`
- **Store:** MySQL
- **Key fields:** `id`, `customer_id`, `channel_id`, `is_active`, `shipping_method`, `coupon_code`, `grand_total`, `base_grand_total`, `sub_total`, `tax_total`, `additional` (JSON), `created_at`
- **Relationships:** belongs to `customers`; has many `cart_items`; has one billing and shipping `cart_addresses`; has one `cart_payment`
- **Confidence:** High
- **Source:** `packages/Webkul/Checkout/src/Models/Cart.php`

### CartItem
- **Table:** `cart_items`
- **Store:** MySQL
- **Key fields:** `id`, `cart_id`, `product_id`, `parent_id`, `type`, `name`, `sku`, `qty`, `price`, `base_price`, `total`, `base_total`, `additional` (JSON)
- **Confidence:** High
- **Source:** `packages/Webkul/Checkout/src/Models/CartItem.php`

### Product
- **Table:** `products`
- **Store:** MySQL
- **Key fields:** `id`, `type` (simple / configurable / virtual / downloadable / grouped / bundle / booking), `sku`, `attribute_family_id`, `parent_id`
- **Note:** Product attributes (name, price, description, etc.) are stored in an EAV pattern across `product_attribute_values` — not as direct columns. For searchable/listable attributes, see `ProductFlat`.
- **Relationships:** has many `product_flat` (one per locale/channel), `product_inventories`, `product_images`, `product_reviews`, `product_attribute_values`; belongs to many `categories`, `channels`
- **Confidence:** High
- **Source:** `packages/Webkul/Product/src/Models/Product.php`

### ProductFlat
- **Table:** `product_flat`
- **Store:** MySQL
- **Key fields:** `id`, `product_id`, `locale`, `channel`, `sku`, `name`, `url_key`, `short_description`, `description`, `price`, `special_price`, `special_price_from`, `special_price_to`, `status`, `new`, `featured`, `weight`, `parent_id`
- **Note:** Denormalised table for fast product listing/search — one row per product per locale per channel. Query this instead of EAV for listings.
- **Confidence:** High
- **Source:** `packages/Webkul/Product/src/Models/ProductFlat.php`

### ProductInventory
- **Table:** `product_inventories`
- **Store:** MySQL
- **Key fields:** `id`, `qty`, `product_id`, `inventory_source_id`, `vendor_id`
- **Note:** No timestamps. One row per product per inventory source.
- **Confidence:** High
- **Source:** `packages/Webkul/Product/src/Models/ProductInventory.php`

### ProductReview
- **Table:** `product_reviews`
- **Store:** MySQL
- **Key fields:** `id`, `product_id`, `customer_id`, `name`, `title`, `comment`, `rating` (integer), `status` (pending / approved / disapproved), `created_at`
- **Confidence:** High
- **Source:** `packages/Webkul/Product/src/Models/ProductReview.php`

### Wishlist (WishlistItem)
- **Table:** `wishlist_items`
- **Store:** MySQL
- **Key fields:** `id`, `customer_id`, `product_id`, `channel_id`, `shared`, `additional` (JSON), `created_at`
- **Confidence:** High
- **Source:** `packages/Webkul/Customer/src/Models/Wishlist.php`

### InventorySource
- **Table:** `inventory_sources`
- **Store:** MySQL
- **Key fields:** `id`, `code`, `name`, `contact_name`, `contact_email`, `contact_number`, `status`, `country`, `state`, `city`, `street`, `postcode`
- **Note:** Represents a warehouse or fulfilment location. Products have qty per inventory source.
- **Confidence:** Medium (no explicit fillable — inferred from usage and migration naming)
- **Source:** `packages/Webkul/Inventory/src/Models/InventorySource.php`

### Channel
- **Table:** `channels`
- **Store:** MySQL
- **Key fields:** `id`, `code`, `name`, `description`, `hostname`, `default_locale_id`, `base_currency_id`, `root_category_id`, `theme`, `is_maintenance_on`
- **Note:** Multi-store support — each store front is a Channel. Orders, customers, carts are scoped to a channel.
- **Confidence:** High
- **Source:** `packages/Webkul/Core/src/Models/Channel.php`

---

## Events (Laravel internal event bus — not Kafka)

Bagisto uses Laravel's `Event::dispatch('string.name', $payload)` pattern. These are in-process events, not a message queue.

### Order lifecycle
| Event | When fired | Payload |
|---|---|---|
| `checkout.order.save.before` | Before order is created from cart | `[$data]` (cart data array) |
| `checkout.order.save.after` | After order created | `$order` (Order model) |
| `checkout.order.orderitem.save.before` | Before each order item saved | `$item` |
| `checkout.order.orderitem.save.after` | After each order item saved | `$orderItem` |
| `sales.order.cancel.before/after` | Order cancelled | `$order` |
| `sales.order.update-status.before/after` | Order status changed | `$order` |
| `sales.order.comment.create.after` | Comment added to order | `$comment` |

### Invoice / Shipment / Refund
| Event | When fired |
|---|---|
| `sales.invoice.save.before/after` | Invoice created |
| `sales.shipment.save.before/after` | Shipment created |
| `sales.refund.save.before/after` | Refund created |

### Customer lifecycle
| Event | When fired |
|---|---|
| `customer.registration.before/after` | Customer registers |
| `customer.after.login` | Customer logs in |
| `customer.after.logout` | Customer logs out |
| `customer.create.before/after` | Customer created (admin) |
| `customer.update.before/after` | Customer updated |
| `customer.delete.before/after` | Customer deleted |
| `customer.password.update.after` | Password changed |

### Cart
| Event | When fired |
|---|---|
| `checkout.cart.add.before/after` | Item added to cart |
| `checkout.cart.update.before/after` | Cart item updated |
| `checkout.cart.delete.before/after` | Cart item removed |
| `checkout.cart.collect.totals.before/after` | Cart totals recalculated |

### Product / Catalog
| Event | When fired |
|---|---|
| `catalog.product.create.before/after` | Product created |
| `catalog.product.update.before/after` | Product updated |
| `catalog.product.delete.before/after` | Product deleted |
| `catalog.category.create/update/delete.after` | Category changes |

---

## Data Stores

| Type | Name / Connection | What it holds |
|---|---|---|
| MySQL 8.0 | `DB_DATABASE` (see `.env`) | All application data — orders, customers, products, inventory, carts |
| Redis | `REDIS_HOST:6379` | Cache (`CACHE_STORE=file` by default, Redis available), sessions, queues |
| Elasticsearch | `localhost:9200` | Product search index (via docker-compose; `elasticsearch:7.17.0`) |
| Local filesystem | `storage/app/public` | Product images, customer avatars, uploaded files (`FILESYSTEM_DISK=public`) |

---

## API Endpoints (Shop REST API — prefix: `/api`)

| Method | Path | What it does |
|---|---|---|
| GET | `/api/core/countries` | List countries |
| GET | `/api/core/states` | List states |
| GET | `/api/categories` | List categories |
| GET | `/api/categories/tree` | Category tree |
| GET | `/api/categories/attributes` | Filterable attributes for a category |
| GET | `/api/products` | Product listing (paginated, filterable) |
| GET | `/api/products/{id}/related` | Related products |
| GET | `/api/products/{id}/up-sell` | Up-sell products |
| GET | `/api/product/{id}/reviews` | Product reviews |
| POST | `/api/product/{id}/review` | Submit a review |
| GET | `/api/checkout/cart` | Get current cart |
| POST | `/api/checkout/cart` | Add item to cart |
| PUT | `/api/checkout/cart` | Update cart items |
| DELETE | `/api/checkout/cart` | Clear cart |
| POST | `/api/checkout/cart/coupon` | Apply coupon |
| POST | `/api/checkout/cart/estimate-shipping-methods` | Get shipping options |
| GET | `/api/checkout/onepage/summary` | Checkout summary |
| POST | `/api/checkout/onepage/addresses` | Save checkout address |
| POST | `/api/checkout/onepage/shipping-methods` | Select shipping method |
| POST | `/api/checkout/onepage/payment-methods` | Select payment method |
| POST | `/api/checkout/onepage/orders` | Place order |
| POST | `/api/customer/login` | Customer login |
| GET | `/api/customer/addresses` | List saved addresses (auth) |
| POST | `/api/customer/addresses` | Add address (auth) |
| PUT | `/api/customer/addresses/edit/{id}` | Update address (auth) |
| GET | `/api/customer/wishlist` | Get wishlist (auth) |
| POST | `/api/customer/wishlist` | Add to wishlist (auth) |
| DELETE | `/api/customer/wishlist/{id}` | Remove from wishlist (auth) |

**Note:** Admin panel API routes (in `packages/Webkul/Admin/`) were not scanned — see Coverage Gaps.

---

## Coverage Gaps

- **Admin API routes** — `packages/Webkul/Admin/` routes not scanned. Admin has its own set of REST endpoints for managing orders, products, customers, etc.
- **Product attribute values (EAV)** — Product attributes (name, price, description, etc.) live in `product_attribute_values` table with dynamic columns per attribute type. Field names depend on the attribute family configuration, not static PHP columns. Check `packages/Webkul/Attribute/src/` for the attribute system.
- **Queue/Jobs** — 17 job classes found (e.g. import, email notifications). Job payloads and queue configuration (`QUEUE_CONNECTION=sync` by default) not mapped.
- **Elasticsearch index schema** — Product search uses Elasticsearch but the index field mapping was not inspected. Check `packages/Webkul/Product/src/` for indexing logic.
- **Payment gateway data** — Payment-specific fields are stored in `order_payment.additional` (JSON). Structure varies by gateway (Stripe, PayPal, etc.).
- **Booking product tables** — BookingProduct package has its own set of tables for appointment/event/rental slots. Not mapped in detail.
