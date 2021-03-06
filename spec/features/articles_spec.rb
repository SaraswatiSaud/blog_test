require 'rails_helper'

RSpec.feature 'Articles', type: :feature do
  before(:each) do
    @user = FactoryGirl.create(:user)

    visit root_path
    click_link 'Login'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
  end

  scenario 'user creates new article' do
    expect {
      click_link 'New Article'
      fill_in 'Title', with: 'Test Article'
      fill_in 'Text', with: 'This is test article'
      click_button 'Create Article'
    }.to change(@user.articles, :count).by(1)
    expect(page).to have_content 'Test Article'
  end

  scenario 'user creates a show page'do
    article = FactoryGirl.create(:article, user: @user)
    visit articles_path
    click_link 'Show'
    expect(page).to have_content(article.title)
    expect(page).to have_content(article.text)
  end

  scenario 'user edits an article' do
    article = FactoryGirl.create(:article, user: @user)

    expect {
      visit edit_article_path(article.id)
      fill_in 'Title', with: 'Edited Article'
      fill_in 'Text', with: 'This is edited article'
      click_button 'Update Article'
    }.to_not change(@user.articles, :count)

    expect(article.reload.title).to eq 'Edited Article'
    expect(page).to have_content 'Article updated successfully.'
  end

  scenario 'user deletes an article' do
    article = FactoryGirl.create(:article, user: @user)

    expect {
      visit articles_path
      click_link 'Destroy'
    }.to change(@user.articles, :count).by(-1)
  end

  scenario 'user logout the page' do
    article = FactoryGirl.create(:article, user: @user)
    visit articles_path
    click_link 'logout'
    expect(page).to have_content 'Signed out successfully.'
  end
end
