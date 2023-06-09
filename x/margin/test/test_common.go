package test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"

	gridapp "github.com/Gridchain/gridnode/app"
)

func CreateTestApp(isCheckTx bool) (*gridapp.GridchainApp, sdk.Context) {
	app := gridapp.Setup(isCheckTx)
	ctx := app.BaseApp.NewContext(isCheckTx, tmproto.Header{})
	app.AccountKeeper.SetParams(ctx, authtypes.DefaultParams())
	initTokens := sdk.TokensFromConsensusPower(1000, sdk.DefaultPowerReduction)
	_ = gridapp.AddTestAddrs(app, ctx, 6, initTokens)
	return app, ctx
}

func CreateTestAppMargin(isCheckTx bool) (sdk.Context, *gridapp.GridchainApp) {
	gridapp.SetConfig((false))
	app := gridapp.Setup(isCheckTx)
	ctx := app.BaseApp.NewContext(isCheckTx, tmproto.Header{})
	return ctx, app
}

func CreateTestAppMarginFromGenesis(isCheckTx bool, genesisTransformer func(*gridapp.GridchainApp, gridapp.GenesisState) gridapp.GenesisState) (sdk.Context, *gridapp.GridchainApp) {
	gridapp.SetConfig(false)
	app := gridapp.SetupFromGenesis(isCheckTx, genesisTransformer)
	ctx := app.BaseApp.NewContext(isCheckTx, tmproto.Header{})
	return ctx, app
}
