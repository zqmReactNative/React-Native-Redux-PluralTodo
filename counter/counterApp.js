// counterApp.js
import React, { Component } from 'react';
import { binActionCreators } from 'redux';

import Counter from './counter';

import * as counterTypes from './actions/actionTypes';

import { connect } from 'react-redux';

class CounterApp extends Component {
	render() {
		const { state, actions } = this.props;
		return (
			<Counter 
			counter = {state.counter}
			{...actions}
			/>
		);
	}
}

export default connect(state=>({
	state: state.counter
}),
(dispatch)=>({
	actions:bindActionCreators(counterActions, dispatch)
})
)(CounterApp);