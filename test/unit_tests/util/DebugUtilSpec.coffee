#
# Wire
# Copyright (C) 2016 Wire Swiss GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#

# grunt test_init && grunt test_run:util/DebugUtil

describe 'z.util.DebugUtil', ->
  debug_util = null
  test_factory = new TestFactory()

  beforeAll (done) ->
    test_factory.exposeConversationActors()
    .then (conversation_repository) ->
      debug_util = new z.util.DebugUtil window.user_repository, conversation_repository
      done()
    .catch done.fail

  describe 'get_number_of_clients_in_conversation', ->
    it 'gets the amount of all clients in the current conversation (including own clients)', ->
      conversation_repository = debug_util.conversation_repository

      first_client = new z.client.Client()
      first_client.id = '5021d77752286cac'

      second_client = new z.client.Client()
      second_client.id = '575b7a890cdb7635'

      third_client = new z.client.Client()
      third_client.id = '6c0daa855d6b8b6e'

      user_et = new z.entity.User()
      user_et.devices.push first_client
      user_et.devices.push second_client

      second_user_et = new z.entity.User()
      second_user_et.devices.push third_client

      conversation_et = conversation_repository.conversation_mapper.map_conversation entities.conversation
      conversation_et.participating_user_ets.push user_et
      conversation_et.participating_user_ets.push second_user_et

      conversation_repository.conversations.push conversation_et
      conversation_repository.active_conversation conversation_et

      amount = debug_util.get_number_of_clients_in_conversation()
      expect(amount).toBe 4
