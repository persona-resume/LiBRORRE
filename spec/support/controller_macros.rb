module ControllerMacros
  def login_as_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = User.create(name: "利用者テスト", email: "user@librorre.com", password: "abcdefg", deleted_user: false, admin: false)
    sign_in user
  end

  def login_as_admin
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = User.create(name: "管理者テスト", email: "admin01@librorre.com", password: "abcdefg", deleted_user: false, admin: true)
    sign_in admin
  end
end
