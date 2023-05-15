// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CONSTRUCTOR {
    /* constructor
        생성자. 초기값 정해주는 것임.
        한 컨트렉트 당 1개만 가능함.
    */
    uint a;
    uint b;

    constructor() {
        b = 4;
    }

    function setA() public {
        a = 5;
    }

    function getA() public view returns(uint) {
        return b;
    }

    function getB() public view returns(uint) {
        return b;
    }

}

contract CONSTRUCTOR2 {

    uint a;
    constructor(uint _a) {
        a = _a;
    }

    function getA() public view returns(uint) {
        return a;
    }

}

contract CONSTRUCTOR3 {
    struct Student {
        string name;
        uint number;
    }

    Student s;

    constructor(string memory _name, uint _number) {
        s = Student(_name, _number);
    }

    function getStudent() public view returns(Student memory) {
        return s;
    }
}


contract CONSTRUCTOR4 {
    uint a;

    constructor(uint _a) {
        if(_a > 5) {
            a = a;
        } else {
            a = _a * 2;
        }
    }
}

    /*
        1. 1번 지갑으로 배포, value는 10eth로
        2. 배포 후 지갑 잔고 확인
        3. 2번 지갑으로 deposit() 1eth // 3,4,5번 지갑으로 똑같이 실행
        4. 지갑 잔고 확인 후, 2번 지갑으로 trnasferTo 시도, _to의 지갑 주소는 6번 지갑 금액은 5eth 
        5. 1번 지갑으로 transferTo 시도, _to의 지갑 주소는 6번 지갑 금액은 5eth
        6. 2번 지갑으로 withdraw 함수 시도, 1번 지갑으로 withdraw 함수 시도
    */

contract CONSTRUCTORS {
    // 특정 지갑 주소에 특정 금액만큼 보내는 함수
    function send(address payable _a, uint _amount) public {
        _a.transfer(_amount);
    }


    address payable owner;
    constructor() payable {
        // 해당 컨트렉트는 돈을 받고 싶음.
        payable(this).transfer(msg.value);  
        owner = payable(msg.sender);
    }

    function getOwner() public view returns(address) {
        return owner;
    }



    // 컨트렉트가 _to 에게 돈을 보냄.
    function transferTo(address payable _to, uint _amount) public {
        require(msg.sender == owner, "only owner can transfer asset");
        _to.transfer(_amount);
    }

    receive() external payable{}
    // 컨트렉트가 받는 함수를 실행했을 때 작동함수
    // 일반 거래(별도의 호출되는 함수 없을 때)시 해당 contract가 돈을 받을 수 있게 해주는 함수

    // contract가 msg.value만큼 돈을 받는 함수
    function deposit() public payable returns(uint) {
        return msg.value;
    }


    // contract 가 owner에게 전액 돈을 보내는 함수, owner 입장에서는 전액 인출
    function withdraw() public {
        require(msg.sender == owner, "only owner can transfer asset");
        owner.transfer(address(this).balance);
    }

    // contract 가 owner에게 _amount 만큼 보내는 함수, owner 입장에서는 전액 인출
    function withdraw2(uint _amount) public {
        require(msg.sender == owner, "only owner can transfer asset");
        owner.transfer(_amount /* _amount * 10 ** 18 */);
    }

    // contract 가 owner에게 1 ether 보내는 함수, owner 입장에서는 전액 인출
    function withdraw3() public {
        require(msg.sender == owner, "only owner can transfer asset");
        owner.transfer(1 ether);
    }

}


contract MODIFIER1 {
    uint a;

    modifier lessThanFive() {
        require(a < 5, "shold be less than five");
        _;  // 함수가 실행되는 시점        _;  // 함수가 실행되는 시점
    }
    
    
    function aPlus() public {
        a++;
    }

    function aMinus() public {
        a--;
    }

    function getA() public view returns(uint) {
        return a;
    }

    function doubleA() public lessThanFive {
        a = a * 2;
    }
    // 자동으로 lessThanFive 함수를 통과해야 실행함.

    function plusTen() public {
        require(a < 5);
        a += 10;
    }
}

contract MODIFIER2 {

    uint a;

    modifier plusOneBefore() {
        _;
        a++;
        _;
        _;
    }

    modifier plusOneAfter() {
        _;
        a++;
    }

    function setA() public plusOneBefore returns(string memory) {
        if (a >= 3) {
            return "A";
        } else {
            return "B";
        }
    }

    function setC() public plusOneBefore returns(uint) {
        a = a * 3;
        return a;
    }

    function setB() public plusOneAfter returns(string memory) {
        if (a >= 3) {
            return "A";
        } else {
            return "B";
        }
    }

}



contract MODIFIER3 {

    uint a;
    string b;
    string[] b2;

    modifier 

}