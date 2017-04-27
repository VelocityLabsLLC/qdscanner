import React from 'react';
import BarcodeApp from '../components/BarcodeApp';
import getMuiTheme from 'material-ui/styles/getMuiTheme';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import injectTapEventPlugin from 'react-tap-event-plugin';

injectTapEventPlugin();

const muiTheme = getMuiTheme({
  appBar: {
    height: 64,
  },
});

export default class Scan extends React.Component {
  render() {
    return (
      <MuiThemeProvider muiTheme={muiTheme}>
        <BarcodeApp />
      </MuiThemeProvider>
    );
  }
};