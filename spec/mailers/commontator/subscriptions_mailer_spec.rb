require 'rails_helper'

module Commontator
  RSpec.describe SubscriptionsMailer, type: :mailer do
    let(:mail) { SubscriptionsMailer.comment_created(@comment, @recipients) }
    before(:each) do
      setup_mailer_spec
      @user2 = DummyUser.create
      @thread.subscribe(@user)
      @thread.subscribe(@user2)
      @comment = Comment.new
      @comment.thread = @thread
      @comment.creator = @user
      @comment.body = 'Something'
      @comment.save!
      @recipients = @thread.subscribers.reject{|s| s == @user}
    end

    it 'must create deliverable mail' do
      expect(mail.to).to eq I18n.t('commontator.email.undisclosed_recipients')
      expect(mail.cc).to be_nil
      expect(mail.bcc.size).to eq 1
      expect(mail.bcc).to include(@user2.email)
      expect(mail.subject).not_to be_empty
      expect(mail.body).not_to be_empty
      expect(mail.deliver_now).to eq mail
    end

    context 'allows to set "from" based on comment' do
      before { @thread.config.email_from_proc = lambda { |comment| comment.creator.email } }

      it { expect(mail.from).to eql(['dummy_user1@example.com']) }
    end
  end
end

