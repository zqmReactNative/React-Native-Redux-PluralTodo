// TodoListView.js
import React, { Component, PropTypes } from 'react';
import ReactNative, { View, ListView, StyleSheet, Text, TextInput, TouchableOpacity } from 'react-native';

export default class TodoListView extends Component {
	render() {
		return (
			<View>
				<View style={{flexDirection: 'row'}}>
					<TouchableOpacity />
					<TouchableOpacity />
					<TouchableOpacity />
				</View>
			</View>
		);
	}
}
