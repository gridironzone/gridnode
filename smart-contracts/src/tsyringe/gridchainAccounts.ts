import {HardhatRuntimeEnvironment} from "hardhat/types";
import {HardhatRuntimeEnvironmentToken,} from "./injectionTokens";
import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";
import {inject, injectable} from "tsyringe";
import {isHardhatRuntimeEnvironment} from "./hardhatSupport";

/**
 * The accounts necessary for testing a gridchain system
 */
export class GridchainAccounts {
    constructor(
        readonly operatorAccount: SignerWithAddress,
        readonly ownerAccount: SignerWithAddress,
        readonly pauserAccount: SignerWithAddress,
        readonly validatatorAccounts: Array<SignerWithAddress>,
        readonly availableAccounts: Array<SignerWithAddress>
    ) {
    }
}

/**
 * Note that the hardhat environment provides accounts as promises, so
 * we need to wrap a GridchainAccounts in a promise.
 */
@injectable()
export class GridchainAccountsPromise {
    accounts: Promise<GridchainAccounts>

    constructor(accounts: Promise<GridchainAccounts>);
    constructor(@inject(HardhatRuntimeEnvironmentToken) hardhatOrAccounts: HardhatRuntimeEnvironment | Promise<GridchainAccounts>) {
        if (isHardhatRuntimeEnvironment(hardhatOrAccounts)) {
            this.accounts = hreToGridchainAccountsAsync(hardhatOrAccounts)
        } else {
            this.accounts = hardhatOrAccounts
        }
    }
}

export async function hreToGridchainAccountsAsync(hardhat: HardhatRuntimeEnvironment): Promise<GridchainAccounts> {
    const accounts = await hardhat.ethers.getSigners()
    const [operatorAccount, ownerAccount, pauserAccount, validator1Account, ...extraAccounts] = accounts
    return new GridchainAccounts(operatorAccount, ownerAccount, pauserAccount, [validator1Account], extraAccounts)
}
