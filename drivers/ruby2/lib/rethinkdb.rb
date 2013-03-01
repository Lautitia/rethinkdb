# Copyright 2010-2012 RethinkDB, all rights reserved.
require 'rubygems'
require 'ql2.pb.rb'
require 'socket'
require 'pp'

load 'exc.rb'
load 'net.rb'
load 'shim.rb'
load 'func.rb'
load 'pp.rb'

class Term2
  attr_accessor :context
end

module RethinkDB
  module Shortcuts
    def r(*args)
      args == [] ? RQL.new : RQL.new.expr(*args)
    end
  end

  module Utils
    def get_mname(i = 0)
      caller[i]=~/`(.*?)'/
      $1
    end
    def unbound_if (x, name = nil)
      name = get_mname(1) if not name
      raise NoMethodError, "undefined method `#{name}'" if x
    end
  end

  class RQL
    include Utils
    def initialize(body = nil)
      @body = body
      @body.context = RPP.sanitize_context caller if @body
    end

    def pp
      unbound_if !@body
      RethinkDB::RPP.pp(@body)
    end
    def inspect
      @body ? pp : super
    end
  end
end