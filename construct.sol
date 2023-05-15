// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CONSTRUCTOR {
    // constructor : 생성자. 초기값 정해주는 것임.

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