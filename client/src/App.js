import React, { Component } from 'react';
import Particles from 'react-particles-js';
import {Layout} from 'antd';
import particlesConfig from './config/particles-config';
import NavBar from './components/presentational/nav-bar/nav-bar';

import './App.css';
import YoskContainer from "./components/containers/yosk-container";

const { Content } = Layout;

class App extends Component {
  render() {
    return (
      <div className="App">
          <Layout>
              <Content>
                  <Particles params={particlesConfig} className="particles" />
                  <YoskContainer/>
              </Content>
              <NavBar />
          </Layout>
      </div>
    );
  }
}

export default App;
