import copy
import logging

import burn_lock_functions
import test_utilities
from burn_lock_functions import EthereumToGridchainTransferRequest
from integration_env_credentials import gridchain_cli_credentials_for_test
from test_utilities import get_shell_output, GridchaincliCredentials


def generate_minimal_test_account(
        base_transfer_request: EthereumToGridchainTransferRequest,
        target_ceth_balance: int = 10 ** 18,
        timeout=burn_lock_functions.default_timeout_for_ganache
) -> (EthereumToGridchainTransferRequest, GridchaincliCredentials):
    """Creates a test account with ceth.  The address for the new account is in request.gridchain_address"""
    assert base_transfer_request.ethereum_address is not None
    new_account_key = get_shell_output("uuidgen")
    credentials = gridchain_cli_credentials_for_test(new_account_key)
    logging.info(f"Python |=====: generated credentials")
    new_addr = burn_lock_functions.create_new_gridaddr(credentials=credentials, keyname=new_account_key)
    new_gridaddr = new_addr["address"]
    credentials.from_key = new_addr["name"]
    logging.info(f"Python |=====: generated address")
    request: EthereumToGridchainTransferRequest = copy.deepcopy(base_transfer_request)
    request.gridchain_address = new_gridaddr
    request.amount = target_ceth_balance
    request.gridchain_symbol = "ceth"
    request.ethereum_symbol = "eth"
    logging.debug(f"transfer {target_ceth_balance} eth to {new_gridaddr} from {base_transfer_request.ethereum_address}")
    logging.info(f"Python |=====: transfer_ethereum_to_gridchain request :{request.as_json()}")
    burn_lock_functions.transfer_ethereum_to_gridchain(request, timeout)

    logging.info(
        f"created gridchain addr {new_gridaddr} with {test_utilities.display_currency_value(target_ceth_balance)} ceth")
    return request, credentials


def generate_test_account(
        base_transfer_request: EthereumToGridchainTransferRequest,
        rowan_source_integrationtest_env_transfer_request: EthereumToGridchainTransferRequest,
        rowan_source_integrationtest_env_credentials: GridchaincliCredentials,
        target_ceth_balance: int = 10 ** 18,
        target_rowan_balance: int = 10 ** 18
) -> (EthereumToGridchainTransferRequest, GridchaincliCredentials):
    """Creates a test account with ceth and rowan"""
    new_account_key = get_shell_output("uuidgen")
    credentials = gridchain_cli_credentials_for_test(new_account_key)
    new_addr = burn_lock_functions.create_new_gridaddr(credentials=credentials, keyname=new_account_key)
    new_gridaddr = new_addr["address"]
    credentials.from_key = new_addr["name"]

    if target_rowan_balance > 0:
        rowan_request: EthereumToGridchainTransferRequest = copy.deepcopy(
            rowan_source_integrationtest_env_transfer_request)
        rowan_request.gridchain_destination_address = new_gridaddr
        rowan_request.amount = target_rowan_balance
        logging.debug(f"transfer {target_rowan_balance} rowan to {new_gridaddr} from {rowan_request.gridchain_address}")
        test_utilities.send_from_gridchain_to_gridchain(rowan_request, rowan_source_integrationtest_env_credentials)

    request: EthereumToGridchainTransferRequest = copy.deepcopy(base_transfer_request)
    request.gridchain_address = new_gridaddr
    request.amount = target_ceth_balance
    request.gridchain_symbol = "ceth"
    request.ethereum_symbol = "eth"
    if target_ceth_balance > 0:
        logging.debug(f"transfer {target_ceth_balance} eth to {new_gridaddr} from {base_transfer_request.ethereum_address}")
        burn_lock_functions.transfer_ethereum_to_gridchain(request)

    logging.info(
        f"created gridchain addr {new_gridaddr} "
        f"with {test_utilities.display_currency_value(target_ceth_balance)} ceth "
        f"and {test_utilities.display_currency_value(target_rowan_balance)} rowan"
    )

    return request, credentials


def create_new_gridaddr() -> str:
    new_account_key = test_utilities.get_shell_output("uuidgen")
    credentials = gridchain_cli_credentials_for_test(new_account_key)
    new_addr = burn_lock_functions.create_new_gridaddr(credentials=credentials, keyname=new_account_key)
    return new_addr["address"]
