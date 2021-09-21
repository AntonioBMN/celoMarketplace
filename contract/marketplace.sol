// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Marketplace {  
    uint internal productCount;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct Product {
        address payable owner;
        string name;
        string image;
        string description;
        string location;
        uint price;
        uint sold;
    }
    mapping (uint => Product) IdToProducts;
    
    function writeProduct(
		string memory _name,
		string memory _image,
		string memory _description, 
		string memory _location, 
		uint _price
	) public {
		uint _sold = 0;
		IdToProducts[productCount] = Product(
			payable(msg.sender),
			_name,
			_image,
			_description,
			_location,
			_price,
			_sold
		);
		productCount++;
	}
    
    function readProduct(uint _index) public view returns (
		address payable,
		string memory, 
		string memory, 
		string memory, 
		string memory, 
		uint, 
		uint
	) {
		return (
			IdToProducts[_index].owner, 
			IdToProducts[_index].name, 
			IdToProducts[_index].image, 
			IdToProducts[_index].description, 
			IdToProducts[_index].location, 
			IdToProducts[_index].price,
			IdToProducts[_index].sold
		);
	}
	
	function buyProduct(uint _index) public payable  {
		require(
		  IERC20Token(cUsdTokenAddress).transferFrom(
			msg.sender,
			IdToProducts[_index].owner,
			IdToProducts[_index].price
		  ),
		  "Transfer failed."
		);
		IdToProducts[_index].sold++;
	}
	
	function getProductsLength() public view returns (uint) {
        return (productCount);
    }
    
}
