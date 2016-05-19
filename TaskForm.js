import React, { Component, PropTypes } from 'react';
import { StyleSheet, View, Text, TextInput, TouchableHighlight, ListView } from 'react-native';

export default class TaskForm extends Component {

	static propTypes = {
		onAdd: PropTypes.func.isRequired,
		onCancel: PropTypes.func.isRequired,
	}

	constructor(props, context) {
		super(props, context);
		this.state = {
			text: '',
		};
	}

	_onAdd = ()=>{
		console.log('onAdd');
		if (this.props.onAdd) {
			this.props.onAdd({task: this.state.text});
		}
	}
	_onCancel = ()=>{
		console.log('onCancel');
		if (this.props.onCancel) {
			this.props.onCancel();
		}
	}

	render(){
		return (
			<View style={styles.container}>
				<TextInput
					style={styles.textInput}
					onChangeText={(text) => this.setState({text})}
					value = {this.state.text}
					/>

				<TouchableHighlight onPress={this._onAdd} style={styles.button}>
					<Text style={styles.buttonTitle}>Add</Text>
				</TouchableHighlight>

				<TouchableHighlight onPress={this._onCancel} style={[styles.button, styles.cancelButton]}>
					<Text style={styles.buttonTitle}>Cancel</Text>
				</TouchableHighlight>
			</View>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		paddingTop: 64,
		backgroundColor: '#e7e7e7'
	},
	textInput: {
		height: 50,
		borderWidth: 1,
		borderColor: '#ccc',
		marginLeft: 10,
		marginRight: 10,
	},
	button: {
		height: 40,
		backgroundColor: '#222',
		marginLeft: 10,
		marginRight: 10,
		marginTop: 10,
		alignItems: 'center',
		justifyContent: 'center',
	},
	buttonTitle: {
		color: '#e7e7e7',
		fontSize: 20,
		fontWeight: '300',
	},
	cancelButton: {
		backgroundColor: '#666',
	},
});
