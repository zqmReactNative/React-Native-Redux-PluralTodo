import React, { Component, PropTypes } from 'react';
import { StyleSheet, View, Text, ListView, TouchableHighlight } from 'react-native';

import TaskRow from './TaskRow';

export default class TaskList extends Component {

  static propTypes = {
    todos: PropTypes.arrayOf(PropTypes.object).isRequired,
    onAddStarted: PropTypes.func.isRequired,
  }
  constructor(props, context)
  {
    super(props, context);
    const ds = new ListView.DataSource({
      rowHasChanged:(r1, r2)=> r1 !== r2,
    });
    this.state = {
      dataSource: ds.cloneWithRows(props.todos),
    };
  }

  _renderRow(rowData){
    return (
      <TaskRow todo={rowData} />
    );
  }

  render() {
    return (
      <View style={styles.container}>
        <ListView
          dataSource={this.state.dataSource}
          renderRow={this._renderRow}
          />
        <TouchableHighlight
          style={styles.button}
          onPress={this.props.onAddStarted}
          >
          <Text style={styles.buttonText}>
            Add One Cell
          </Text>
        </TouchableHighlight>
      </View>

    );
  }
}

const styles = StyleSheet.create({
  container: {
    paddingTop: 40,
    backgroundColor: '#e7e7e7',
    flex: 1,
    justifyContent: 'flex-start',
  },
  button:{
    backgroundColor: '#333',
    height: 60,
    borderWidth: 1,
    borderColor: '#333',
    margin: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  buttonText:{
    color: '#fafafa',
    fontSize: 20,
    fontWeight: '300',
  },
});
