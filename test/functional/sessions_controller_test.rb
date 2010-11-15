require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  fixtures :sessions, :users

  test "Login Required for actions that modify records" do
    get :show, :topic_id => sessions( :tracs ).topic_id, :id => sessions( :tracs ).id
    assert_response :success
    
    get :new, :topic_id => sessions( :tracs ).topic_id
    assert_response :redirect
    
    get :create, :topic_id => sessions( :tracs ).topic_id
    assert_response :redirect

    delete :destroy, :topic_id => sessions( :tracs ).topic_id, :id => sessions( :tracs ).id
    assert_response :redirect    
    assert !sessions( :tracs ).cancelled
  end
  
  test "Admins can do anything" do
    login_as( users( :admin1 ) )
    get :show, :topic_id => sessions( :tracs ).topic_id, :id => sessions( :tracs ).id
    assert_response :success
    
    get :new, :topic_id => sessions( :tracs ).topic_id
    assert_response :success
    
    get :create, :topic_id => sessions( :tracs ).topic_id, :session => { :topic_id => sessions( :tracs ).topic_id }
    assert_response :success

    delete :destroy, :topic_id => sessions( :tracs ).topic_id, :id => sessions( :tracs ).id
    assert_response :redirect    
    assert sessions( :tracs ).reload.cancelled
  end
  
  test "Instructors can delete own sessions" do
    login_as( users( :instructor2 ) )
    get :show, :topic_id => sessions( :tracs ).topic_id, :id => sessions( :tracs ).id
    assert_response :success
    
    get :new, :topic_id => sessions( :tracs ).topic_id
    assert_response :redirect
    
    get :create, :topic_id => sessions( :tracs ).topic_id, :session => { :topic_id => sessions( :tracs ).topic_id }
    assert_response :redirect

    delete :destroy, :topic_id => sessions( :tracs ).topic_id, :id => sessions( :tracs ).id
    assert_response :redirect    
    assert sessions( :tracs ).reload.cancelled
  end
  
  test "Regular users should be able to view, but not make changes" do
    login_as( users( :plainuser1 ) )
    get :show, :topic_id => sessions( :tracs ).topic_id, :id => sessions( :tracs ).id
    assert_response :success
    
    get :new, :topic_id => sessions( :tracs ).topic_id
    assert_response :redirect
    
    get :create, :topic_id => sessions( :tracs ).topic_id, :session => { :topic_id => sessions( :tracs ).topic_id }
    assert_response :redirect

    delete :destroy, :topic_id => sessions( :tracs ).topic_id, :id => sessions( :tracs ).id
    assert_response :redirect    
    assert !sessions( :tracs ).cancelled
  end
  
  test "Session page should show whether a user is registered" do
    login_as( users( :plainuser1 ) )
    get :show, :topic_id => sessions( :gato ).topic_id, :id => sessions( :gato ).id
    assert_match /You are registered for this session/, @response.body

    login_as( users( :plainuser2 ) )
    get :show, :topic_id => sessions( :gato ).topic_id, :id => sessions( :gato ).id
    assert_no_match /You are registered for this session/, @response.body
  end
  
  test "Should be able to download subscribable calendar without credentials" do
    get :download
    assert_response :success
    assert_equal @response.content_type, 'text/calendar'
  end
    
  test "Should display printable attendance sheet" do
    login_as( users( :instructor2 ) )
    get :attendance, {'id' => sessions( :gato )}
    assert_response :success
    assert_not_nil assigns(:session)
    assert_not_nil assigns(:items)
    assert_select "ul" do |elements|
      assert_equal elements.length, assigns(:page_count)
    end
  end
  
end
