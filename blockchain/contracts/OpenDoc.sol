// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@5.0.1/access/Ownable.sol";

contract OpenDoc is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;
    address[] public minters;
    uint256 public MINT_PRICE = 5 ether;
    constructor(address initialOwner)
        ERC721("OpenDoc", "HM")
        Ownable(initialOwner)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmWdxUz7scPHoTftyHVCERs5UgaaiptkAFpg5P9vXgi9w5/";
    }

    function withdraw() public onlyOwner{
        require(address(this).balance > 0, "No balance in the contract");
        payable(owner()).transfer(address(this).balance);
    }

    function addInstitution(address minter) external onlyOwner{
		require(!isAddressAllowed(minter), "Institution is Already added");
        minters.push(minter);
    }

    function removeInstitution(address removed) external onlyOwner {
        uint256 indexToRemove = findAddressIndex(removed);

        require(indexToRemove < minters.length, "Institution is not added");

        minters[indexToRemove] = minters[minters.length - 1];
		
        minters.pop();
    }

    // Internal function to find the index of an address in the array
    function findAddressIndex(address targetAddress) internal view returns (uint256) {
        for (uint256 i = 0; i < minters.length; i++) {
            if (minters[i] == targetAddress) {
                return i;
            }
        }
        return type(uint256).max; // Return a value indicating the address was not found
    }

    function isAddressAllowed(address caller) public view returns (bool) {
        for (uint256 i = 0; i < minters.length; i++) {
            if (minters[i] == caller) {
                return true;
            }
        }
        return false;
    }

    function issue(address to, string memory uri) public payable{
        require(msg.value <= MINT_PRICE, "Not Enogh Etheruem");
        require(isAddressAllowed(msg.sender), "You are Not an Institution");
        uint256 tokenId = ++_nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
