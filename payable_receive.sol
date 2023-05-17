// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

// receive와 payable
/* 실습가이드
    B (deposit_payablem, transferTo 함수 보유)
    C1(receive, deposit_payable 함수 보유), C2(deposit_payable 함수 보유, receive 없음)

    결론
    B -> C1은 전송 가능. 돈만 보내는거임!
    B -> C2는 불가능. B에서 호출하지만 호출되는 함수명(receive)이 없기때문.
    B -> C2만 불가능한 것이 아닌 일반 거래는 불가능함(사람이 전송하는 것도)
    C2가 스스로 자기 컨트렉트에 넣는건 가능함. 
*/

contract B {
    function deposit() public payable {}

    uint eth = 1 ether;  // 지금 상황에서는 지역변수가 더 경제적. 보통의 경우 여러 payable 함수들에 사용되므로 상태변수로 설정

    function transferTo(address payable _to, uint amount) public {
        _to.transfer(amount * eth);
    }
}

contract C1 {
    function deposit() public payable{}
    receive() external payable{}
}

contract C2 {
    function deposit() public payable{}
}