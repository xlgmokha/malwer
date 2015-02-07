module Agents
  class FilesController < ApplicationController
    before_action :load_agent
    before_action do
      request.format = :json
    end

    def index
    end

    def show
      @fingerprint = params[:id]
      @file = Disposition.find_by(fingerprint: params[:id])
      message = {
        agent_id: params[:id],
        type: 'lookup',
        data: params[:data]
      }
      Publisher.publish("events.scanned.#{@agent.id}", message)
    end

    private

    def load_agent
      @agent = Agent.find(params[:agent_id])
    end
  end
end
