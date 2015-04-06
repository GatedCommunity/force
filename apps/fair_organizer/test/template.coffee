_ = require 'underscore'
jade = require 'jade'
path = require 'path'
fs = require 'graceful-fs'
Backbone = require 'backbone'
{ fabricate } = require 'antigravity'
Fair = require '../../../models/fair'
Fairs = require '../../../collections/fairs'
FairOrganizer = require '../../../models/fair_organizer'
Profile = require '../../../models/profile'
Articles = require '../../../collections/articles'
CoverImage = require '../../../models/cover_image'
SearchResult = require '../../../models/search_result'
Item = require '../../../models/item'
Items = require '../../../collections/items'
OrderedSet = require '../../../models/ordered_set'
OrderedSets = require '../../../collections/ordered_sets'
fixtures = require '../../../test/helpers/fixtures.coffee'
cheerio = require 'cheerio'
sinon = require 'sinon'

render = (templateName) ->
  filename = path.resolve __dirname, "../templates/#{templateName}.jade"
  jade.compile(
    fs.readFileSync(filename),
    { filename: filename }
  )

describe 'Fair Organizer', ->
  describe 'index page', ->

    before (done) ->
      sd =
        CANONICAL_MOBILE_URL: 'http://localhost:5000'
        APP_URL: 'http://localhost:5000'
        API_URL: 'http://localhost:5000'
        CSS_EXT: '.css.gz'
        JS_EXT: '.js.gz'
        NODE_ENV: 'test'
        CURRENT_PATH: '/cool-fair'
        PROFILE: fabricate 'fair_organizer_profile'
        FAIR_ORG: fabricate 'fair_organizer'
      fairOrg = new FairOrganizer (sd.FAIR_ORG)
      profile = new Profile (sd.PROFILE)

      pastFairs = new Fairs [fabricate('fair'), fabricate('fair')]

      editorialItems = new Items [fabricate 'featured_link', { title: 'Japanese Art' }]
      editorialItems.add new Item( fabricate 'featured_link', { title: 'Chinese Art' } )
      editorialItems.add new Item( fabricate 'featured_link', { title: 'Moar Chinese Art' } )

      pastFairs.each (fair) ->
        fair.representation = editorialItems

      template = render('overview')
        sd: sd
        fairOrg: fairOrg
        newestFair: pastFairs.models[0]
        pastFairs: pastFairs.models
        profile: profile
        asset: (->)
      @$template = cheerio.load template
      done()

    it 'renders without errors', ->
      @$template.html().should.not.containEql 'undefined'
      @$template.html().should.containEql 'Explore Armory Show Fair Organizer'

