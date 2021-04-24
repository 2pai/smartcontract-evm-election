// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @author Muhammad Iqbal Syamil Ayasy
/// @title An example election smart contract (EVM)
contract Voting{

    /// Emit Winner of election when `endVoting` was called
    /// @param winnerCandidate name of candidate
    /// @param totalCount total ballot of candidate 
    event Winner(string winnerCandidate, uint totalCount);

    bool public isVoteActive; // status voting 
    address public owner; // address deployer
    uint public endEpoch; // end of voting epoch

    struct Voter {
        bool voted;  // if true, that person already voted
        bool eligible; // person delegated to
        int vote;   // index of the voted candidate
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "This method can only called from owner");
        _;
    }

    struct Candidate {
        string name; // candidate Name
        uint voteCount; // number of count
        bool validCandidate; // is a valid candidate or not
    }

    /// stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    /// A dynamically-sized array of `candidate` structs.
    Candidate[] public candidate;
    
    /// Init Contract by set owner = msg.sender, set end period & init candidate
    constructor (string[] memory candidateNameList) {
        isVoteActive = true; 
        owner = msg.sender; // set owner contract = deployer
        endEpoch = block.timestamp + 259200; // set voting active (+3 Days) after Contract Deployed
        
        // list candidate (order = index)
        for (uint256 p = 0; p < candidateNameList.length; p++) {
            candidate.push(Candidate(
                candidateNameList[p],
                0,
                true
            ));            
        }

    }

    /// set the voting period to end (require epoch <= current block timestamp)
    /// @dev when the winner is picked, emit `Winner`event
    function endVoting() public onlyOwner {
        require(endEpoch <= block.timestamp, "Epoch are not less than the current block.timestamp");

        uint largest = 0;
        uint winnerCandidate;
        for (uint256 i = 0; i < candidate.length; i++) {
            if(candidate[i].voteCount > largest){
                winnerCandidate = i;
            }
        }

        emit Winner(candidate[winnerCandidate].name, candidate[winnerCandidate].voteCount);
        isVoteActive = false;
    }

    /// delegate vote to voters address, can only accesible from owner
    /// @param voterAddress address of voter to delegate vote
    function delegateVote(address voterAddress) public onlyOwner {
        require(!voters[voterAddress].voted,"The Address Is already on the List");
        voters[voterAddress].voted = false;
        voters[voterAddress].eligible = true;
        voters[voterAddress].vote = -1; // set default to -1

    }
    /// mass delegate vote to list voters address, can only accesible from owner
    /// @param listVoterAddress list of address of voter to delegate vote
    function massDelegateVote(address[] memory listVoterAddress) public onlyOwner {
        for (uint256 p = 0; p < listVoterAddress.length; p++) {
            delegateVote(listVoterAddress[p]);
        }
    }
    
    /// vote the candidate
    /// @param numberCandidate index of candidate
    /// @dev increment the state of `voteCount` on candidate struct by +1
    function vote(uint numberCandidate) public {

        require(isVoteActive, "Voting period Has Ended."); // check voting period is still active
        require(voters[msg.sender].eligible, "You're Not eligible to vote"); // check if voter are eligible
        require(!voters[msg.sender].voted, "The voter already voted."); // check if voters has not voted yet
        require(candidate[numberCandidate].validCandidate,"Candidate Number is Invalid"); // check candidate 
        
        candidate[numberCandidate].voteCount = candidate[numberCandidate].voteCount + 1;
        voters[msg.sender].vote = int(numberCandidate);
        voters[msg.sender].voted = true; 
            
        
    }
}