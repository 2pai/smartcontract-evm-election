pragma solidity ^0.8.0;

contract Voting{

    bool public voteActive; // status voting 
    address public owner; // address deployer
    uint public epoch; // end of voting epoch
    struct Voter {
        bool voted;  // if true, that person already voted
        bool eligible; // person delegated to
        uint vote;   // index of the voted candidate
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    struct Candidate {
        string name; // candidate Name
        uint voteCount; // number of count
        bool validCandidate; // is a valid candidate or not
    }

    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `candidate` structs.
    Candidate[] public candidate;

    constructor () public {
        voteActive = true; 
        owner = msg.sender; // set owner contract = deployer
        epoch = block.timestamp + 259200; // set voting active (+3 Days) after Contract Deployed
        
        // list candidate (order = index)
        candidate.push(Candidate(
            'Iqbal',
            0,
            true
        ));
        candidate.push(Candidate(
            'Syamil',
            0,
            true
        ));
        
    }

    // set the voting period to end (require epoch <= current block timestamp)
    function endVoting() public onlyOwner {
        require(epoch <= block.timestamp, "Epoch are not less than current block.timestamp");
        voteActive = false;
    }

    // delegate vote to voters address, can only accesible from owner; 
    function delegateVote(address addressVoter) public onlyOwner {
        require(!voters[addressVoter].voted,"The Address Is already on the List");
        Voter memory vote = voters[addressVoter];
        vote.voted = false;
        vote.eligible = true;

    }
    
    // function to vote, takes candidate number (index) as params
    function vote(uint candidateNumber) public {

        require(voteActive, "Voting period Has Ended."); // check voting period is still active
        require(voters[msg.sender].eligible, "You're Not eligible to vote"); // check if voter are eligible
        require(!voters[msg.sender].voted, "The voter already voted."); // check if voters has not voted yet
        require(candidate[candidateNumber].validCandidate,"Candidate Number is Invalid"); // check candidate 
        
        candidate[candidateNumber].voteCount = candidate[candidateNumber].voteCount + 1;
        voters[msg.sender].vote = candidateNumber;
        voters[msg.sender].voted = true; 
            
        
    }
}