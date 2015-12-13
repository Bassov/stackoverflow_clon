# encoding: utf-8
require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :attachable }
end
