_ = require 'underscore'
sd = require('sharify').data
Backbone = require 'backbone'
CurrentUser = require '../../../models/current_user.coffee'
Partner = require '../../../models/partner.coffee'
overviewLayoutFactory = require './overview_layout_factory.coffee'
template = -> require('../templates/overview.jade') arguments...

module.exports = class PartnerOverviewView extends Backbone.View

  initialize: (options = {}) ->
    { @profile, @partner } = _.defaults options, @defaults
    @isPartner = @partner.get('claimed') isnt false
    @showBanner = not @isPartner and not @partner.get 'show_promoted'

    @$el.html template partner: @partner, showBanner: @showBanner, isPartner: @isPartner, modules: @moduleNames()
    @initLayout()

  initLayout: ->
    _.each overviewLayoutFactory(@partner), (module) =>
      new module.component?(
        _.extend module.options, el: @$(".partner-overview-section[data-module=#{module.name}]")
      ).startUp()

  # Available module names
  moduleNames: ->
    _.map overviewLayoutFactory(@partner), (m) -> m.name