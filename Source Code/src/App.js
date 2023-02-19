import { Products } from './components/products';
import contents from './content';
import { useState } from 'react';
import { EmbedSDK } from "@pushprotocol/uiembed";
import { useEffect } from 'react';
import "@rainbow-me/rainbowkit/styles.css"
import {configureChains, createClient, WagmiConfig} from "wagmi"
import { alchemyProvider } from 'wagmi/providers/alchemy'
import {publicProvider} from 'wagmi/providers/public'
import {getDefaultWallets, RainbowKitProvider} from '@rainbow-me/rainbowkit'
import { goerli, mainnet } from '@wagmi/core'
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { connectorsForWallets } from "@rainbow-me/rainbowkit";
import { metaMaskWallet } from "@rainbow-me/rainbowkit/wallets";
import { ArcanaConnector } from "@arcana/auth-wagmi";
import Button from 'react-bootstrap/Button';
import { Chat } from "@pushprotocol/uiweb";






const {

  ConstructorFragment,
  EventFragment,
  Fragment,
  FunctionFragment,
  ParamType,
  FormatTypes,

  AbiCoder,
  defaultAbiCoder,

  Interface,
  Indexed,

  /////////////////////////
  // Types

  CoerceFunc,
  JsonFragment,
  JsonFragmentType,

  Result,
  checkResultErrors,

  LogDescription,
  TransactionDescription

} = require("@ethersproject/abi");

//chains
//connectors
export const ArcanaRainbowConnector = ({ chains }) => {
  return {
    id: "arcana-auth",
    name: "Arcana Wallet",
    iconUrl: "",
    iconBackground: "#101010",
    createConnector: () => {
      const connector = new ArcanaConnector({
        chains,
        options: {
          // appId parameter refers to App Address value in the Dashboard
          appId: "20B0B836C92D91Ba2059d6Fa76073Ac431A56B64",
        },
      });
      return {
        connector,
      };
    },
  };
};

const connectors = (chains) =>
  connectorsForWallets([
    {
      groupName: "Recommended",
      wallets: [ArcanaRainbowConnector({ chains }), metaMaskWallet({ chains })],
    },
  ]);


const {chains,provider} = configureChains(
  [mainnet,goerli],
  [
    alchemyProvider({apikey:""}),
    publicProvider(),
  ]
)

// const {connectors} = getDefaultWallets({
//   appName : "Rainbowkit Tutorial",
//   chains,
// })

const wagmiClient = createClient({
  autoconnect : true,
  connectors : connectors(chains),
  provider,
})

export default function App() {
   const account = window.ethereum
  useEffect(() => {
    if (account) { // 'your connected wallet address'
      EmbedSDK.init({
        headerText: 'Hello DeFi', // optional
        targetID: 'sdk-trigger-id', // mandatory
        appName: 'consumerApp', // mandatory
        user: account, // mandatory
        chainId: 1, // mandatory
        viewOptions: {
            type: 'sidebar', // optional [default: 'sidebar', 'modal']
            showUnreadIndicator: true, // optional
            unreadIndicatorColor: '#cc1919',
            unreadIndicatorPosition: 'bottom-right',
        },
        theme: 'light',
        onOpen: () => {
          console.log('-> client dApp onOpen callback');
        },
        onClose: () => {
          console.log('-> client dApp onClose callback');
        }
      });
    }

    return () => {
      EmbedSDK.cleanup();
    };
  }, []);
  return (
    <WagmiConfig client={wagmiClient}>
      <RainbowKitProvider chains = {chains}>
    <div className='App'>
      {contents.map((contents) => (
        <Products
          key={contents.id}
          image={contents.image}
          name={contents.name}
          price={contents.price}
          rating={contents.rating}
          location={contents.location}
          tokens={contents.totalTokens}
          area={contents.landArea}
        />
      ))}
    </div>
    <div>
         <button className = "button" id="sdk-trigger-id">Notifs</button>
    </div>
    <ConnectButton/> 
    <Chat
   account={"0x60E7c5F82744fEEcDE75B9771F0235CA8b9E4Bf0"}//user address
   supportAddress="0x6c32a3f4e13732E6b482Faeb52e78e2780734cBe" //support address
   apiKey="Zc423i0lYv.Cq3NIUgTpxbBhREUDFz79oTjEjqhc5FzhbQ0Oe8kXNaEyv20LehF6Xfgmog78j1H"
    env="staging"
 />
    <Chat
   account={"0x60E7c5F82744fEEcDE75B9771F0235CA8b9E4Bf0"}//user address
   supportAddress="0x6c32a3f4e13732E6b482Faeb52e78e2780734cBe" //support address
   apiKey="Zc423i0lYv.Cq3NIUgTpxbBhREUDFz79oTjEjqhc5FzhbQ0Oe8kXNaEyv20LehF6Xfgmog78j1H"
    env="staging"
 />
    <Chat
   account={"0x60E7c5F82744fEEcDE75B9771F0235CA8b9E4Bf0"}//user address
   supportAddress="0x6c32a3f4e13732E6b482Faeb52e78e2780734cBe" //support address
   apiKey="Zc423i0lYv.Cq3NIUgTpxbBhREUDFz79oTjEjqhc5FzhbQ0Oe8kXNaEyv20LehF6Xfgmog78j1H"
    env="staging"
 />

    </RainbowKitProvider>
     </WagmiConfig>
     
  );
}
