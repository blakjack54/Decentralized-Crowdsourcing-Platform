// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdsourcing {
    struct Task {
        address creator;
        string description;
        uint256 reward;
        bool completed;
        address completer;
    }

    uint256 public taskCount;
    mapping(uint256 => Task) public tasks;

    event TaskCreated(uint256 taskId, address creator, string description, uint256 reward);
    event TaskCompleted(uint256 taskId, address completer);

    function createTask(string memory description) external payable {
        require(msg.value > 0, "Reward must be greater than zero");

        taskCount++;
        tasks[taskCount] = Task(msg.sender, description, msg.value, false, address(0));
        emit TaskCreated(taskCount, msg.sender, description, msg.value);
    }

    function completeTask(uint256 taskId) external {
        Task storage task = tasks[taskId];
        require(!task.completed, "Task already completed");
        require(task.creator != msg.sender, "Creator cannot complete the task");

        task.completed = true;
        task.completer = msg.sender;
        payable(msg.sender).transfer(task.reward);
        emit TaskCompleted(taskId, msg.sender);
    }

    function getTask(uint256 taskId) external view returns (address creator, string memory description, uint256 reward, bool completed, address completer) {
        Task storage task = tasks[taskId];
        return (task.creator, task.description, task.reward, task.completed, task.completer);
    }
}
