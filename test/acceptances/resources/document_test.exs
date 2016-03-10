defmodule Acceptances.Resources.DocumentTest do
  use ExUnit.Case

  alias Tirexs.{HTTP, Resources}


  setup do
    HTTP.delete("bear_test") && :ok
  end

  test "_bulk/0" do
    actions = ~S'''
    { "index": { "_index": "website", "_type": "blog", "_id": "1" }}
    { "title":    "My second blog post" }
    '''
    # { :ok, 200, r } = HTTP.post("/_bulk", actions)
    # { :ok, 200, r } = Resources.bump(actions)._bulk({ [refresh: true] })
    { :ok, 200, r } = Resources.bump(actions)._bulk()
    refute r[:errors]
  end

  test "_bulk/0 w/ macro" do
    import Tirexs.Bulk
    actions = bulk do
      index [ _index: "website", _type: "blog", _id: 1, title: "My second blog post" ]
    end
    { :ok, 200, r } = Resources.bump(actions)._bulk()
    refute r[:errors]
  end

  test "_bulk/2" do
    actions = ~S'''
    { "index": { "_id": "2" }}
    { "title":    "My second blog post" }
    '''
    # { :ok, 200, r } = HTTP.post("/_bulk", actions)
    # { :ok, 200, r } = Resources.bump(actions)._bulk({ [refresh: true] })
    { :ok, 200, r } = Resources.bump(actions)._bulk("website", "blog")
    refute r[:errors]
  end
end
