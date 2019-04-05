pragma solidity ^0.4.23;

contract Faucet {
    address public constant VTHOADDRESS = address(0x0000000000000000000000000000456E65726779);
    uint256 public constant DURATION = 48 hours;
    uint256 public constant AMOUNT = 2888 ether;
    uint256 public constant BEGIN = 1551888000; // 2019/3/7 0:0:0
    uint256 public constant LIMIT = 20; // 一天只允许20次领取
    uint256 public constant DAY = 24 hours;

    struct Donation {
        uint256 amount;
        uint256 lastDonateTime;
    }
    mapping(address => Donation) public donations;
    address[] public donationAddrs;

    mapping(address => uint256) public lastGetTime;
    mapping(uint256 => uint256) public alreadyAsk;

    address owner;
    
    event Donate(address indexed _owner, uint256 indexed _amount);
    event AskVTHO(address indexed _owner, uint256 indexed _amount);

    constructor() public {
        owner = msg.sender;
    }
    function donate(uint256 _amountvet) public {
        uint256 _amount = _amountvet*10**18;
        IERC20 vTHO = IERC20(VTHOADDRESS);
        vTHO.transferFrom(msg.sender,address(this), _amount);

        donations[msg.sender].amount += _amount;
        donations[msg.sender].lastDonateTime = now;

        emit Donate(msg.sender, _amount);

        for (uint256 i = 0; i < donationAddrs.length; i++) {
            if(donationAddrs[i] == msg.sender) {
                return;
            }
        }

        donationAddrs.push(msg.sender);
    }

    function askVTHO(uint256 _a) public {
        require(lastGetTime[msg.sender] + DURATION < now);
        require(_a >= 0);
        uint256 _indexDay = (now - BEGIN) / DAY + 1;
        require(alreadyAsk[_indexDay] <= LIMIT);

        IERC20 vTHO = IERC20(VTHOADDRESS);
        vTHO.transfer(msg.sender, AMOUNT);
        lastGetTime[msg.sender] = now;
        alreadyAsk[_indexDay]++;

        emit AskVTHO(msg.sender, AMOUNT);
    }

    function ownerGet() public {
        require(msg.sender == owner);
        IERC20 vTHO = IERC20(VTHOADDRESS);
        vTHO.transfer(msg.sender, vTHO.balanceOf(address(this)) );
    }

    function ownerGetVet() public {
        require(msg.sender == owner);
        msg.sender.transfer(address(this).balance);
    }
    // view
    function todayAsked() public view returns(uint256 _amount) {
        uint256 _indexDay = (now - BEGIN) / DAY + 1;
        _amount = alreadyAsk[_indexDay];
    }

    function getBlance() public view returns(uint256 _balance) {
        IERC20 vTHO = IERC20(VTHOADDRESS);
        _balance = vTHO.balanceOf(address(this));
    }

    // 拿到Donation.amount是第_index的对应数据
    function getDonations(uint256 _index) public view returns(address _owner, uint256 _amount, uint256 _lastDonateTime) {
        require(_index <= donationAddrs.length && _index > 0);
        address[] memory _temp = new address[](donationAddrs.length);
        uint256 _tempMax;
        address _tempMaxAddress;
        uint256 _tempMaxIndex;
        address _tempbook;

        for(uint256 k = 0; k < donationAddrs.length; k++) {
            _temp[k] = donationAddrs[k];
        }

        

        for(uint256 i = 0; i < donationAddrs.length; i++) {
            for (uint256 j = i; j < donationAddrs.length; j++) {
                if (donations[_temp[j]].amount > _tempMax) {
                    _tempMax = donations[_temp[j]].amount;
                    _tempMaxAddress = _temp[j];
                    _tempMaxIndex = j;
                }
            }
            _tempbook = _temp[i];
            _temp[i] = _tempMaxAddress;
            _temp[_tempMaxIndex] = _tempbook;

            _tempMax = 0;
        }

        _owner =  _temp[_index-1];
        _amount = donations[_owner].amount;
        _lastDonateTime = donations[_owner].lastDonateTime;        
    }

    function getDonationAmount() public view returns(uint256 _length) {
        _length = donationAddrs.length;
    }
}


/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}