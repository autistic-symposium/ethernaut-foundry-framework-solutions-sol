pragma solidity ^0.8.10;


contract Reentrance {
    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool success, ) = msg.sender.call{value: _amount}("");
            if (success) {
                _amount;
            }
            // unchecked to prevent underflow errors
            unchecked {
                balances[msg.sender] -= _amount; 
            }
        }
    }

    receive() external payable {}
}