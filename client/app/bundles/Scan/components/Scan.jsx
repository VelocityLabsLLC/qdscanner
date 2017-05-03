import React from 'react';
import BarcodeApp from '../components/BarcodeApp';
// import darkBaseTheme from 'material-ui/styles/baseThemes/darkBaseTheme';
import getMuiTheme from 'material-ui/styles/getMuiTheme';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import injectTapEventPlugin from 'react-tap-event-plugin';
// import {indigo500, indigo700, redA200} from 'material-ui/styles/colors';

import {
  blue800, blue900,
  red900,
  // grey100, grey400, grey500
} from 'material-ui/styles/colors';

injectTapEventPlugin();

const muiTheme = getMuiTheme({
    palette: {
        primary1Color: blue800,
        primary2Color: blue900,
        accent1Color: red900,
        pickerHeaderColor: blue800,
    },
});

// const muiTheme = getMuiTheme({
  // palette: {
  //   primary1Color: greenA500,
  //   primary2Color: greenA700,
  //   primary3Color: grey400,
  //   accent1Color: red900,
  //   accent2Color: grey100,
  //   accent3Color: grey500,
  //   pickerHeaderColor: greenA500,
  // },
// });

export default class Scan extends React.Component {
  render() {
    return (
      <MuiThemeProvider muiTheme={muiTheme}>
        <BarcodeApp />
      </MuiThemeProvider>
    );
  }
}