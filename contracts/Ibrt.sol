// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface Ibrt{
    function balanceOf(address owner) external view returns(uint balance);
}