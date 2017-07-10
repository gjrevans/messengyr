import React from 'react';
import ReactDOM from 'react-dom';
import 'whatwg-fetch';

import { createStore } from 'redux';
import { Provider } from 'react-redux';

import ChatContainer from "./components/chat-container";
import MenuContainer from "./components/menu-container";

import rooms from './reducers';

// Our store:
const store = createStore(rooms);

class App extends React.Component {
  render() {
    // Pass the relevant data as props:
    return (
      <div>
        <MenuContainer />
        <ChatContainer />
      </div>
    )
  }
}

ReactDOM.render(
  // The app must be wrapped in a provider so that it can
  // Access the store we created with redux
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('app'),
);
