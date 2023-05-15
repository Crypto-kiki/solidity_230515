// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/* enum, require, payable
자동차를 운전하려고 합니다.
자동차의 상태에는 정지, 운전중, 시동 끔, 연료없음 총 4가지 상태가 있습니다.

정지는 속도가 0인 상태, 운전 중은 속도가 있는 상태이다. 

* 악셀 기능 - 속도를 1 올리는 기능, 악셀 기능을 이용할 때마다 연료가 2씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 70이상이면 악셀 기능은 더이상 못씀
* 브레이크 기능 - 속도를 1 줄이는 기능, 속도가 0인 상태, 브레이크 기능을 이용할 때마다 연료가 1씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
* 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
* 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
* 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨

지불은 smart contract에게 함.
----------------------------------------------------------------------------------------
* 주유소 사장님은 2번 지갑의 소유자임, 주유소 사장님이 withdraw하는 기능
* 지불을 미리 하고 주유시 차감하는 기능
*/

contract QUIZ {

    enum Status {
        stop,
        driving,
        off,
        fuel
    }

    uint speed;
    uint fuel;

    Status status;

    // * 악셀 기능 - 속도를 1 올리는 기능, 악셀 기능을 이용할 때마다 연료가 2씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 70이상이면 악셀 기능은 더이상 못씀
    function Accelerator() public {
        require(speed < 70, "can't accelerator");
        require(fuel > 30, "can't accelerator");
        speed += 1;
        fuel -= 2;
        status = Status.driving;
    }

    //* 브레이크 기능 - 속도를 1 줄이는 기능, 속도가 0인 상태, 브레이크 기능을 이용할 때마다 연료가 1씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    function Break() public {
        require(speed > 0, "Already sttoped");
        speed -= 1;
        fuel -= 1;
    }

    // * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    function Engine_off() public {
        require(speed == 0, "must stop first");
        status = Status.off;
    }

    // * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    function Engine_on() public {
        status = Status.stop;
    }

    address payable owner = payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    
    receive() external payable{}

    // * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    // * 지불을 미리 하고 주유시 차감하는 기능 
    function deposit() public payable {
        require(msg.value == 1 ether, "must pay 1 ether");
        fuel = 100;
    }

    // * 주유소 사장님은 2번 지갑의 소유자임, 주유소 사장님이 withdraw하는 기능
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        owner.transfer(address(this).balance);
    }

    function get() public view returns(uint, uint) {
        return (speed, fuel);
    }

    function checkOwnerBalance() public view returns(uint) {
        return owner.balance / 10 ** 18;
    }

}