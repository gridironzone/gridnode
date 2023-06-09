import logging
import os

import pytest

import burn_lock_functions
from burn_lock_functions import EthereumToGridchainTransferRequest
import test_utilities
from pytest_utilities import generate_test_account
from test_utilities import get_required_env_var, GridchaincliCredentials, get_optional_env_var, ganache_owner_account


def test_rowan_to_erowan(
        basic_transfer_request: EthereumToGridchainTransferRequest,
        source_ethereum_address: str,
        rowan_source_integrationtest_env_credentials: GridchaincliCredentials,
        rowan_source_integrationtest_env_transfer_request: EthereumToGridchainTransferRequest,
        ethereum_network,
        bridgetoken_address,
        smart_contracts_dir
):
    basic_transfer_request.ethereum_address = source_ethereum_address
    basic_transfer_request.check_wait_blocks = True
    target_rowan_balance = 10 ** 18
    request, credentials = generate_test_account(
        basic_transfer_request,
        rowan_source_integrationtest_env_transfer_request,
        rowan_source_integrationtest_env_credentials,
        target_ceth_balance=10 ** 18,
        target_rowan_balance=target_rowan_balance
    )

    logging.info(f"send erowan to ethereum from test account")
    request.ethereum_address, _ = test_utilities.create_ethereum_address(
        smart_contracts_dir, ethereum_network
    )
    request.gridchain_symbol = "rowan"
    request.ethereum_symbol = bridgetoken_address
    request.amount = int(target_rowan_balance / 2)
    burn_lock_functions.transfer_gridchain_to_ethereum(request, credentials)
