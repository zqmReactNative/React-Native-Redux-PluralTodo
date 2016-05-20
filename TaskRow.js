import React, { Component, PropTypes } from 'react';
import { StyleSheet, View, Text, ListView, TouchableHighlight } from 'react-native';

import Swipeout from 'react-native-swipeout';

export default class TaskRow extends Component {
  static propTypes = {
    todo: PropTypes.shape({
      task: PropTypes.string.isRequired,
    }).isRequired,
  }

  _onPressDone = ()=>{
    if (this.props.onDone) {
      this.props.onDone();
    }else {
      alert(0);
    }
  }

  render() {
    const rightButtons = [
      {
        text: 'Done',
        backgroundColor: '#05a5d1',
        underlayColor: '#273539',
        // onPress: this.props.onDone,
      },
    ];
    return (
      <Swipeout
        right={rightButtons}
        >
        <View style={styles.container}>
          <Text>
            {this.props.todo.task}
          </Text>
          <TouchableHighlight onPress={this._onPressDone}>
            <Text>
              Done
            </Text>
          </TouchableHighlight>
        </View>
      </Swipeout>

    );
  }
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: 'pink',
    borderWidth: 1,
    borderColor: '#e7e7e7',
    padding: 20,
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    // marginTop: 20,
    // marginBottom: 20,
    // marginLeft: 20,
    // marginRight: 20,
    margin: 20,
  },

  label: {
    fontSize: 20,
    fontWeight: '300',
  },
});
