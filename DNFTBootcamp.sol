// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.8.2/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.8.2/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/AutomationCompatible.sol";

contract DNFTBootcamp is AutomationCompatibleInterface, ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint interval;
    uint lastTimeStamp;

    enum Status {
        First,
        Second,
        Third
    }

    mapping (uint256 => Status) nftStatus;

    string [] IpfsUri = [
        "https://ipfs.io/ipfs/Qmc4pKG3eBiPFgJNDAhDsaevAB2je5adssK8ZaRakt5MZZ/state_0.json",
        "https://ipfs.io/ipfs/Qmc4pKG3eBiPFgJNDAhDsaevAB2je5adssK8ZaRakt5MZZ/state_1.json",
        "https://ipfs.io/ipfs/Qmc4pKG3eBiPFgJNDAhDsaevAB2je5adssK8ZaRakt5MZZ/state_2.json"
    ];

    constructor(uint _interval) ERC721("DNFTBootcamp", "DBTC") {
        interval = _interval;
        lastTimeStamp = block.timestamp;
    }

    function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory /* performData */) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;        
    }

    function performUpkeep(bytes calldata /* performData */) external override  {        
        if ((block.timestamp - lastTimeStamp) > interval ) {
            lastTimeStamp = block.timestamp;

            updateAllNFTs();            
        }        
    }

    function safeMint(address to, string memory uri) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        //_setTokenURI(tokenId, uri);
        nftStatus[tokenId] = Status(0);
    }

    function updateAllNFTs() public {
        uint256 counter = _tokenIdCounter.current();

        for (uint i = 0; i < counter; i++) {
            updateStatus(i);
        }
    }

    function updateStatus(uint256 _tokenId) public {
        uint256 currentStatus = getNFTStatus(_tokenId);
         nftStatus[_tokenId] = Status((currentStatus + 1) % (uint(type(Status).max) + 1));
    }

    function getNFTStatus(uint256 _tokenId) public view returns(uint256) {
        Status statusindex = nftStatus[_tokenId];
        return uint256(statusindex);
    }

    function getUriByStatus(uint256 _tokenId) public view returns(string memory) {
        Status statusindex = nftStatus[_tokenId];
        return IpfsUri[uint256(statusindex)];
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        // return super.tokenURI(tokenId);
        return getUriByStatus(tokenId);
    }
}
