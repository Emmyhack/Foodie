# FoodDelivery Smart Contract

The **FoodDelivery** contract is a decentralized application built on the Ethereum blockchain, designed for managing food delivery orders, eateries, and dispatch riders. The contract allows customers to place orders, eateries to register, and dispatch riders to be assigned to deliveries.

## Features

- **Order Management**: Customers can place food orders and track the status of their orders (ordered, packed, in transit, delivered).
- **Eatery Registration**: Only verified eateries can register and accept orders.
- **Dispatch Rider Registration**: Dispatch riders can register and get assigned to deliveries.
- **Payment System**: Customers pay for their orders, and the contract ensures the appropriate handling of funds.
- **Order Updates**: The contract supports order status updates as the order progresses.

## Smart Contract Components

1. **FoodDelivery Contract**:
   - Manages customer orders.
   - Allows eateries to register and be verified.
   - Registers dispatch riders and assigns them to deliveries.
   - Handles payments and order status updates.

2. **CustomerOrder Struct**: Represents an individual customer's food order with details such as food name, quantity, payment status, and delivery status.

3. **Eatery Struct**: Represents an eatery with details such as name, location, food genre, and balance.

4. **DispatchRider Struct**: Represents a dispatch rider with details such as name, location, and delivery balance.

## Deployment

### Requirements

- Solidity version 0.8.0 or higher.
- Ethereum or compatible EVM blockchain (e.g., Rinkeby for testing).

### Deployment Steps

1. Deploy the contract using Remix or a local development environment.
2. Pass the initial owner's address when deploying the `FoodDelivery` contract.
3. Register eateries and dispatch riders using the `registerEatery` and `registerDispatch` functions.
4. Customers can place food orders using the `orderFood` function.
5. Dispatch riders will be assigned deliveries and updated through events.

## Usage

1. **Registering an Eatery**: The contract owner can register verified eateries with the `registerEatery` function.
   
2. **Registering a Dispatch Rider**: The contract owner can register dispatch riders with the `registerDispatch` function.
   
3. **Placing an Order**: Customers can place an order by calling the `orderFood` function and paying for their order in Ether.

4. **Order Tracking**: Customers can track the status of their orders as they move through the states (ordered, packed, on transit, delivered).

## Events

- `FoodOrdered`: Emitted when a customer places an order.
- `DispatchAssigned`: Emitted when a dispatch rider is assigned to an order.
- `OrderStatusUpdated`: Emitted when the status of an order is updated.
- `PaymentReceived`: Emitted when a payment is received for an order.
- `FundsWithdrawn`: Emitted when funds are withdrawn by the contract owner.
- `EateryRegistered`: Emitted when an eatery is successfully registered.
- `DispatchRiderRegistered`: Emitted when a dispatch rider is successfully registered.

## Example

```solidity
// Register an eatery
registerEatery("Pizza Place", "New York", address(0x123...));

// Register a dispatch rider
registerDispatch("John's Delivery", "New York", address(0x456...));

// Place an order
orderFood("Italian", "Pizza", "Tomato Sauce", "Extra Cheese", 2, "123 Main St", "Pizza Place");
