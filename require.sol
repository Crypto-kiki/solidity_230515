// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
여러분은 검색 엔진 사이트에서 근무하고 있습니다. 고객들의 ID와 비밀번호를 안전하게 관리할 의무가 있습니다. 따라서 비밀번호를 rawdata(있는 그대로) 형태로 관리하면 안됩니다. 비밀번호를 안전하게 관리하고 로그인을 정확하게 할 수 있는 기능을 구현하세요.

아이디와 비밀번호는 서로 쌍으로 관리됩니다. 
비밀번호는 rawdata가 아닌 암호화 데이터로 관리되어야 합니다.
(string => bytes32)인 mapping으로 관리

value인 bytes32는 ID와 PW를 같이 넣은 후 나온 결과값으로 설정하기
abi.encodePacked() 사용하기

* 로그인 기능 - ID, PW를 넣으면 로그인 여부를 알려주는 기능
* 회원가입 기능 - 새롭게 회원가입할 수 있는 기능
---------------------------------------------------------------------------
* 회원가입시 이미 존재한 아이디 체크 여부 기능 - 이미 있는 아이디라면 회원가입 중지
* 비밀번호 5회 이상 오류시 경고 메세지 기능 - 비밀번호 시도 회수가 5회되면 경고 메세지 반환
* 회원탈퇴 기능 - 회원이 자신의 ID와 PW를 넣고 회원탈퇴 기능을 실행하면 관련 정보 삭제
*/

contract quiz2 {
    mapping(string => User) ID_PW;


    // 로그인 기능 + 비밀번호 오류 5회
    struct User {
        bytes32 hash;
        uint attempts;
    }

    function getHash(string memory _ID, string memory _PW) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_ID, _PW));
    }


    

    // 로그인 기능
    function login(string memory _ID, string memory _PW) public returns(bool) {
        require(ID_PW[_ID].attempts < 5, "Too much attempts");
        if(ID_PW[_ID].hash ==getHash(_ID, _PW)) {
            ID_PW[_ID].attempts = 0;
            return true;
        } else {
            ID_PW[_ID].attempts++;
            return false;
        }
    }

    function login2(string memory _ID) public view returns(bytes32) {
        return ID_PW[_ID].hash;
    }

    // 회원가입 기능
    function signIn(string memory _ID, string memory _PW) public {
        // * 회원가입시 이미 존재한 아이디 체크 여부 기능 - 이미 있는 아이디라면 회원가입 중지
        require(ID_PW[_ID].hash == 0x0000000000000000000000000000000000000000000000000000000000000000, "Provided ID is alreadt being used");
        // require(ID_PW[_ID].hash == "", "Provided ID is alreadt being used"); // 위랑 같은 결과물임.
        ID_PW[_ID].hash = getHash(_ID, _PW);
        // abi.encodePacked는 bytes로 바꿔주기 위함이 아님. 바꿔줄수는 있지만 목적은 contract를 metadata형태로 보여줌.
    }

    // 회원탈퇴 기능
    function signOut(string memory _ID, string memory _PW) public {
        require(ID_PW[_ID].hash == getHash(_ID, _PW));
        // require(login(_ID, _PW) == true);  // login함수가 view가 아닌 돈을 쓰는 함수로 변경되서 다시 위에걸로 바꿈.
        delete ID_PW[_ID];
    }

}

contract practice {

    mapping(string => bytes32) ID_PW;
    string[] ID;
    

    // 회원가입 + 존재하는 아이디 확인
    function signUp(string memory _id, string memory _pw) public {
        for(uint i = 0; i < ID.length; i++) {
            if(keccak256(bytes(ID[i])) == keccak256(bytes(_id))) {
                revert("Already Exist");
            }
        }
        ID_PW[_id] = keccak256(abi.encodePacked(_id, _pw));
        ID.push(_id);
    } 


    // 로그인 기능 + 비밀번호 오류 5회 (내꺼)
    mapping(string => uint) CHECK_PW;
    function signIn(string memory _id, string memory _pw) public returns(uint, bool) {
        if(ID_PW[_id] == keccak256(abi.encodePacked(_id, _pw))) {
            CHECK_PW[_id] = 0;
            return (CHECK_PW[_id], true);
        } else {
            if(CHECK_PW[_id] < 5) {
                CHECK_PW[_id]++;
                return (CHECK_PW[_id], false);
            } else {
                revert("Incorrect Password over 5times");
            }
        }
    }

    // 회원 탈퇴 기능
    function deleteID(string memory _id, string memory _pw) public {
        for(uint i = 0; i < ID.length; i++) {
            if(keccak256(bytes(ID[i])) == keccak256(bytes(_id)) && ID_PW[_id] == keccak256(abi.encodePacked(_pw))) {
                
            }
        }
    }

    function getID() public view returns(string[] memory) {
        return ID;
    }


}



contract REQUIRE {
    // require는 결과적으로 false면 이전의 모든 실행내역을 원래대로 돌려냄.

    function Require1(uint _n) public pure returns(uint) {
        require(_n < 10, "input should be lower than 10");
        return _n * 3;
    }

    function getName(string memory _name) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_name));
    }

    function onlyAlice(string memory _name) public pure returns(bool) {
        require(getName(_name) == 0x9c0257114eb9399a2985f8e75dad7600c5d89fe3824ffa99ec1c3eb8bf3b0501);
        return true;
    }
    // alice: bytes32: 0x9c0257114eb9399a2985f8e75dad7600c5d89fe3824ffa99ec1c3eb8bf3b0501

}

contract REQUIRE2 {

    function getBool() public pure returns(bool) {
        bool a;
        return a;
    }  // 기본 값 false임

    function Require1() public pure returns(uint) {
        uint a = 1;
        bool b;
        require(b, "Error");
        // b = false라 통과 못함!!
        return a;
    }

    uint a;
    function getA() public returns(uint) {
        return a;
    }

    function Require3() public {
        uint b = 3;
        bool c;
        a = 5;
        require(c, "error");  // a를 5로 바꾼 것도 전부 다시 revert(원래 상태로 복구)시킴.
    }

    function Require3_2() public {
        bool c;
        a = 5;
        require(c, "error");  // a를 5로 바꾼 것도 전부 다시 revert(원래 상태로 복구)시킴.
    }


    function setAasFive() public {
        a = 5;
    }

    function Require4() public {
        bool c;
        setAasFive();  // a의 값을 5로 설정하는 외부 함수
        require(c, "error");  // 외부함수 모두 revert
    }

    // require에 조건 2개 가능?
    function Require5(uint _n) public pure returns(bool) {
        require(_n % 5 == 0 && _n > 10, "Nope");
    }

    // 예를 들어, _n을 3으로 나눠서 나머지 1일때, 0일때, 2일때 행동들을 지정하기
    function Require6(uint _n) public pure returns(uint) {
        if(_n%3 ==0) {
            require(_n%3 !=0, "nope");
        } else if (_n%3 == 1) {
            return _n%3;
        } else {
            return _n%3;
        }

        uint b;

        if(_n % 3 == 1) {
            b = b + 1;
            return b;
        } else if(_n%3 == 2) {
            b = b+2;
            return b;
        } else {
            return b;
        }
    }
}