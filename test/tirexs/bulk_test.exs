defmodule Tirexs.BulkTest do
  use ExUnit.Case

  import Tirexs.Bulk


  test "bulk/0 macro" do
    actual = bulk do
      index   _index: "website", _type: "blog", _id: 1, title: "My second blog post"
      delete  _index: "website", _type: "blog", _id: 1
      update  _index: "website", _type: "blog", _id: 1, _retry_on_conflict: 3, title: "My second blog post"
    end
    expected = [
      [ index: [ _index: "website", _type: "blog", _id: "1" ]],
      [ title: "My second blog post" ],
      [ delete: [ _index: "website", _type: "blog", _id: "1" ]],
      [ update: [ _index: "website", _type: "blog", _id: "1", _retry_on_conflict: 3 ]],
      [ doc:    [ title: "My second blog post" ]]
    ]
    assert actual == expected
  end

  test "bulk/1 macro" do
    actual = bulk [ index: "website", type: "blog" ] do
      index   id: 1, title: "My second blog post"
      delete  id: 1
      update  id: 1, _retry_on_conflict: 3, title: "My second blog post"
    end
    expected = [
      [ index: [ _index: "website", _type: "blog", _id: "1" ]],
      [ title: "My second blog post" ],
      [ delete: [ _index: "website", _type: "blog", _id: "1" ]],
      [ update: [ _index: "website", _type: "blog", _id: "1", _retry_on_conflict: 3 ]],
      [ doc:    [ title: "My second blog post" ]]
    ]
    assert actual == expected
  end

  test :get_id_from_document do
    document = [id: "id", title: "Hello"]
    assert get_id_from_document(document) == "id"

    document = [{:id, "id"}, {:title, "Hello"}]
    assert get_id_from_document(document) == "id"

    document = [_id: "_id", title: "Hello"]
    assert get_id_from_document(document) == "_id"

    document = [{:_id, "_id"}, {:title, "Hello"}]
    assert get_id_from_document(document) == "_id"
  end

  test :convert_document_to_json do
    document = [id: "id", title: "Hello"]

    assert convert_document_to_json(document) == "{\"id\":\"id\",\"title\":\"Hello\"}"
  end

  test :get_type_from_document do
    document = [id: "id", title: "Hello", type: "my_type"]

    assert get_type_from_document(document) == "my_type"
  end
end
