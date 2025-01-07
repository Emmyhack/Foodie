// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract FoodDelivery is Ownable, ReentrancyGuard {

    enum State { ordered, packed, onTransit, delivered }

    struct CustomerOrder {
        string foodCategory;
        string foodName;
        string sauceType;
        string indicateAdditionals;
        State orderStatus;
        uint256 quantityPerPlate;
        string homeAddress;
        string dispatchChoice;
        address verifiedEatery;
        address assignedDispatchRider;
        uint256 totalPrice;
        bool paid;
        bool confirmed;
    }

    struct Eatery {
        string name;
        string location;
        string foodGenre;
        uint256 balance;
        bool isVerified;
    }

    struct DispatchRider {
        string dispatchName;
        string currentLocation;
        uint256 numOfDeliveries;
        uint256 balance;
        uint256 servicePrice;
        bool isVerified;
        bool isAvailable;
    }

    mapping(address => CustomerOrder) private orders;
    mapping(address => Eatery) public eateries;
    mapping(address => DispatchRider) public dispatchRiders;

    address[] public registeredDispatchRiders;
    address[] public verifiedEateries;

    event FoodOrdered(string foodName, string sauceType, string indicateAdditionals, string homeAddress, string eateryChoice, uint256 quantityPerPlate);
    event DispatchAssigned(address indexed rider, string dispatchName, address indexed customer, string eateryName, string eateryLocation);
    event OrderStatusUpdated(address indexed customer, State newState);
    event PaymentReceived(address indexed customer, uint256 amount);
    event FundsWithdrawn(address indexed recipient, uint256 amount);
    event EateryRegistered(address indexed eateryAddress, string name);
    event DispatchRiderRegistered(address indexed riderAddress, string name);

    modifier onlyRegisteredEatery() {
        require(eateries[msg.sender].isVerified, "Only Authorized Eatery");
        _;
    }

    //this  Updates the constructor to pass the owner address to the Ownable constructor
    constructor(address initialOwner) Ownable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4) {
        transferOwnership(initialOwner); // Transfer ownership to the specified address
    }

    function registerEatery(string memory _eateryName, string memory _location, address _eateryAddress) public onlyOwner {
        require(!eateries[_eateryAddress].isVerified, "Eatery already registered");
        require(bytes(_eateryName).length > 0, "Eatery name required");
        require(bytes(_location).length > 0, "Location required");

        eateries[_eateryAddress] = Eatery(_eateryName, _location, "Food Genre", 0, true);
        verifiedEateries.push(_eateryAddress);
        emit EateryRegistered(_eateryAddress, _eateryName);
    }

    function registerDispatch(string memory _dispatchName, string memory _currentLocation, address _dispatchAddress) public onlyOwner {
        require(!dispatchRiders[_dispatchAddress].isVerified, "Dispatch rider already registered");
        require(bytes(_dispatchName).length > 0, "Dispatch name required");
        require(bytes(_currentLocation).length > 0, "Current location required");

        dispatchRiders[_dispatchAddress] = DispatchRider(_dispatchName, _currentLocation, 0, 0, 0, true, true);
        registeredDispatchRiders.push(_dispatchAddress);
        emit DispatchRiderRegistered(_dispatchAddress, _dispatchName);
    }

    function orderFood(
        string memory _foodCategory,
        string memory _foodName,
        string memory _sauceType,
        string memory _indicateAdditionals,
        uint256 _quantityPerPlate,
        string memory _homeAddress,
        string memory _eateryChoice
    ) public payable nonReentrant {
        require(msg.value > 0, "Must pay for the order");

        address verifiedEatery = getVerifiedEatery(_eateryChoice);
        uint256 totalPrice = _quantityPerPlate * 10; // Replace with actual price logic

        orders[msg.sender] = CustomerOrder(
            _foodCategory, _foodName, _sauceType, _indicateAdditionals, State.ordered, _quantityPerPlate, _homeAddress, _eateryChoice, verifiedEatery, address(0), totalPrice, false, false
        );

        emit FoodOrdered(_foodName, _sauceType, _indicateAdditionals, _homeAddress, _eateryChoice, _quantityPerPlate);
    }

    function getVerifiedEatery(string memory dispatchChoice) internal view returns (address) {
        for (uint256 i = 0; i < verifiedEateries.length; i++) {
            if (keccak256(abi.encodePacked(eateries[verifiedEateries[i]].name)) == keccak256(abi.encodePacked(dispatchChoice))) {
                return verifiedEateries[i];
            }
        }
        revert("No matching eatery found");
    }
}
