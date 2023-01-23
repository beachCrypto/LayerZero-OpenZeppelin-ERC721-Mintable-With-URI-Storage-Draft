// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "https://github.com/LayerZero-Labs/solidity-examples/blob/main/contracts/token/onft/ONFT721.sol";

contract BeachCryptoTestONFT721 is ONFT721, ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;
    uint public startMintId;
    uint public endMintId;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor(
        string memory _name, 
        string memory _symbol,
        uint256 _minGasToTransfer,
        address _layerZeroEndpoint,
        uint _startMintId,
        uint _endMintId
    ) ONFT721(
            _name, 
            _symbol,
            _minGasToTransfer,
            _layerZeroEndpoint
        ) {
            _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
            _grantRole(MINTER_ROLE, msg.sender);
            startMintId = _startMintId;
            endMintId = _endMintId;
        }

    function _baseURI() internal pure override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmQ1AT7S8DfJ2WA157tsCTmTbW8mQ1zeAtjyYFCjc4e48d/";
    }
    // The following functions are overrides required by Solidity.

    function safeMint(address to, string memory uri) public onlyRole(MINTER_ROLE) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
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
        override(ONFT721, ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
