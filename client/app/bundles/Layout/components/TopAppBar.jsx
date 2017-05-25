/*global $*/
import React from 'react';
import AppBar from 'material-ui/AppBar';
import getMuiTheme from 'material-ui/styles/getMuiTheme';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import FlatButton from 'material-ui/FlatButton';
// import {indigo500, indigo700, redA200} from 'material-ui/styles/colors';
import PropTypes from 'prop-types';

import {
  blue800, blue900,
  red900,
  // grey100, grey400, grey500
} from 'material-ui/styles/colors';


const muiTheme = getMuiTheme({
    palette: {
        primary1Color: blue800,
        primary2Color: blue900,
        accent1Color: red900,
        pickerHeaderColor: blue800,
    },
});



export default class TopAppBar extends React.Component {
  static propTypes = {
    controller: PropTypes.string,
    action: PropTypes.string,
    user: PropTypes.object,
  };
    
  constructor(props) {
    super(props);
    this.state= {
       controller: this.props.controller,
       action: this.props.action,
       logged_in: this._logged_in(this.props.user),
    };
  }
  
  _logged_in = (user) => {
    console.log("logged in?");
    console.log(!(user==null));
    console.log(user);
    return !(user==null);
  }
  
  _handleLogOut = () => {
    console.log("Logging Out");
    this.setState({
      logged_in: !this.state.logged_in,
    });
    $.ajax({
      url: 'users/sign_out',
      type: 'DELETE',
      // data: {}, //
      // contentType:'application/json',  // <
      // dataType: 'text',                // <---update this
      success: function() {console.log("success");},
      error: function(){console.log("failure")}
    });
    $.ajax({
      url: '/pages/home',
      success: function() {console.log("Returned home")},
    });
  }
  
  _handleLogIn = () => {
    console.log("Logging In");
    // this.setState({
    //   logged_in: !this.state.logged_in,
    // });
    $.ajax({
      url: '/users/sign_in',
      success: function() {console.log("Succesfully logged in")},
    });
  }
  
  
  render() {
    return (
      <MuiThemeProvider muiTheme={muiTheme}>
        <AppBar
        style={{position: 'fixed', top: '0px'}}
        title="Velocity Laboratories"
        iconElementRight={<FlatButton label={this.state.logged_in ? "log out" : "log in"} />}
        onRightIconButtonTouchTap={this.state.logged_in ? this._handleLogOut : this._handleLogIn}
        // iconElementLeft={<IconButton onTouchTap={this._handleToggleSettings}><TuneIcon /></IconButton>}
        // onLeftIconButtonTouchTap={this._handleToggleSettings}
       />
      </MuiThemeProvider>
    );
  }
}