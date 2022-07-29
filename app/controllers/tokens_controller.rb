# frozen_string_literal: true

class TokensController < ApplicationController
  # GET /tokens
  def index
    render json: Token.all, status: :ok
  end
end
