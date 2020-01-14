pragma solidity ^0.5.12;

// создаем контракт 
contract Faucet {
    // мэппинг из тех, кто уже получил деньги
    mapping (address => bool) public list;
    // владелец контракта
    address public owner;
    // максимальная сумма
    uint public maxGive = 0.1 ether;
    
    // событие
    event Sent(address to, uint amount);
    
    // конструктор, записываем владельца
    constructor () public {
        owner = msg.sender;
    }

    // функция отправки денег
    function () external payable {
    }

    // функция чтения баланса
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // функция запросы денег
    function giveMe(uint _count) public {
        // если не указана сумма
        require(_count > 0, "How much do you need?");
        // если на контракте нет денег
        require(address(this).balance > 0, "This contract is empty. Please, donate");
        // если на контракте меньше, чем запросили
        if (address(this).balance < _count) {
                _count = address(this).balance;
            }
        // проверка на владельца
        if (msg.sender != owner) {
            // если запросили больше, чем разрешено
            require(_count <= maxGive, "It's too much. See maxGive");
            // если уже запрашивали
            require(list[msg.sender] == false, "You have done it already");
            // добавление в список запросившего
            list[msg.sender] = true;
        }
        // отправка денег
        msg.sender.transfer(_count);
        // создание события
        emit Sent(msg.sender, _count);
    }
}
