// Implement all the function signatures, create and add the appropriate modifiers, make as many internal functions as you want and emit the relevant events
pragma solidity ^0.4.24;

import './ERC721.sol';
import "github.com/Arachnid/solidity-stringutils/strings.sol"; // for string manipulations

contract RaptorFactory {

  address owner;

  event NewRaptor(address indexed owner, uint indexed id, string name);
  event Breeding(uint indexed _matronId, uint indexed _sireId);

  struct Raptor {
    string name;
    uint dna;
  }

  Raptor[] public raptors;

  uint levelUpFee = 0.05 ether;

  mapping (uint => address) public raptorToOwner;
  mapping (address => uint) ownerRaptorCount;
  mapping (address => uint) randomRaptorCount;

  modifier onlyOwnerOfMatron(uint _matronId) {
      require (msg.sender == raptorToOwner[_matronId]);
      _;
  }

  constructor() public {
      owner = msg.sender;
  }

  // Creates a raptor with a dna which is triple the average of the matron and sire's dna's
  
  function breedRaptors(uint _matronId, uint _sireId) external payable onlyOwnerOfMatron(uint _matronId) {
    // YOUR CODE HERE

    uint matronDna = raptors[_matronId].dna;
    uint sireDna   = raptors[_sireDna].dna;

    uint newDna = ((matronDna + sireDna) / 2) * 3;

    Raptor newRaptor = new Raptor;
    newRaptor.name = randName();
    newraptor.dna  = newDna;

    raptors.push(newRaptor);

    emit Breeding(_matronId, _sireId);
  }

  // Creates and mints a raptor to the function caller,
  // with random unique dna (fixed 10-digit number) and name each time its called,
  // and can only be called 5 times by the same address
  
  function createRandomRaptor() public {
    // YOUR CODE HERE

    require(randomRaptorCount[msg.sender] < 5, "too many attempts");

    Raptor newRaptor = new Raptor;
    newRaptor.name = randName();
    newRaptor.dna  = randDna();

    raptors.push(newRaptor);
    uint id = raptors.length;

    randomRaptorCount[msg.sender]++;

    emit NewRaptor(msg.sender, id, newRaptor.name);
  }

  // Gets a list of raptor by owner's address
  function getRaptorsByOwner(address _owner) external view returns(uint[]) {
    // YOUR CODE HERE

    // TBD

  }

  // helper functions ---------------------------

  function randName() private returns(string) {
      
      string memory raptorName       = "Raptor";
      string memory randomEnd        = uint2str(random());
      string memory randomRaptorName = raptorName.toSlice().concat(randomEnd.toSlice()); 
  }

  function randDna() private returns (uint) {
      return random();
  }

  function random() private returns (uint) {
      return uint(uint256(keccak256(block.timestamp, block.difficulty))%251);
  }

  function uint2str (uint i) internal pure returns (string) {
    if(i == 0) return "0";
    uint j = i;
    uint length;
    while (j!=0) {
        length++;
        j /10;
    }
    bytes memory bstr = new bytes(length);
    uint k = length - 1;
    while (i != 0) {
        bstr[k--] = byte(48 + i % 10);
        i /= 10;
    }
    return string(bstr);
  }
}