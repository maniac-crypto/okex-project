// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract buymeCup {



    uint256 public lastRequestId;


    uint256 public timestamp;


    bool public pending;

    // Organization that wants to receive the funds
    struct Organization {
        string name;
        string description;
        bool isFunded; // is organization funded
        uint256 target; // target funding in wei (1 ether = 10^18 wei)
        address owner; // Owner of the ngo
        uint256 funds;
    }

    uint256 public organizationId;

    // mapping of organizationId to Organization object
    mapping(uint256 => Organization) public organizations;

    // Details of a particular funding
    struct Funding {
        uint256 organizationId;
        uint256 fundAmount;
        address user;
    }

    uint256 public fundingId;

    // mapping of fundingId to Funding object
    mapping(uint256 => Funding) public fundings;

    // This event is emitted when a new organization is put up for funding
    event NewOrganization (
        uint256 indexed organizationId
    );

    // This event is emitted when a NewFunding is made
    event NewFunding (
        uint256 indexed organizationId,
        uint256 indexed fundingId
    );


    uint64 public newNumber;

    /*
   * Token name.
   */
    string internal tokenName;

    /*
     * Token symbol.
     */
    string internal tokenSymbol;

    /*
     * Number of decimals.
     */
    uint8 internal tokenDecimals;

    /*
     * Total supply of tokens.
     */
    uint256 internal tokenTotalSupply;

    /*
     * Balance information map.
     */
    mapping (address => uint256) internal balances;

    /*
     * Token allowance mapping.
     */
    mapping (address => mapping (address => uint256)) internal allowed;

    /*
     * @dev Trigger when tokens are transferred, including zero value transfers.
     */
    event Transfer(address indexed _from,address indexed _to,uint256 _value);

    /*
     * @dev Trigger on any successful call to approve(address _spender, uint256 _value).
     */
    event Approval(address indexed _owner,address indexed _spender,uint256 _value);

    /*
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory _name){
        _name = tokenName;
    }

    /*
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory _symbol){
        _symbol = tokenSymbol;
    }

    /*
     * @dev Returns the number of decimals the token uses.
     */
    function decimals() external view returns (uint8 _decimals){
        _decimals = tokenDecimals;
    }

    /*
     * @dev Returns the total token supply.
     */
    function totalSupply()external view returns (uint256 _totalSupply){
        _totalSupply = tokenTotalSupply;
    }

    /*
     * @dev Returns the account balance of another account with address _owner.
     * @param _owner The address from which the balance will be retrieved.
     */
    function balanceOf(address _owner) external view returns (uint256 _balance){
        _balance = balances[_owner];
    }

    /*
     * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
     * function SHOULD throw if the "from" account balance does not have enough tokens to spend.
     * @param _to The address of the recipient.
     * @param _value The amount of token to be transferred.
     */
    function transfer(address payable _to, uint256 _value) public returns (bool _success){
        require(balances[msg.sender]>=_value, "error: insufficient funds");
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        _success = true;
    }

    /*
     * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. If
     * this function is called again it overwrites the current allowance with _value. SHOULD emit the Approval event.
     * @param _spender The address of the account able to transfer the tokens.
     * @param _value The amount of tokens to be approved for transfer.
     */
    function approve(address _spender,uint256 _value) public returns (bool _success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        _success = true;
    }

    /*
     * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
     * @param _owner The address of the account owning tokens.
     * @param _spender The address of the account able to transfer the tokens.
     */
    function allowance(address _owner,address _spender) external view returns (uint256 _remaining){
        _remaining = allowed[_owner][_spender];
    }

    /*
     * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
     * Transfer event.
     * @param _from The address of the sender.
     * @param _to The address of the recipient.
     * @param _value The amount of token to be transferred.
     */
    function transferFrom(address _from,address _to,uint256 _value) public returns (bool _success){
        require(balances[_from]>=_value);
        require(allowed[_from][msg.sender]>=_value);
        balances[_from] = balances[_from] - _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        _success = true;
    }

}
