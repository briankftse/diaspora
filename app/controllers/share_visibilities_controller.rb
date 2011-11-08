#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.
#

class ShareVisibilitiesController < ApplicationController
  before_filter :authenticate_user!

  def update
    #note :id references a postvisibility
    params[:shareable_id] ||= params[:post_id]
    params[:shareable_type] ||= 'Post'

    vis = current_user.toggle_hidden_shareable(accessible_post)
    RedisCache.update_cache_for(current_user, accessible_post, vis)
    render 'update'
  end

  protected

  def accessible_post
    @post ||= params[:shareable_type].constantize.where(:id => params[:post_id]).select("id, guid, author_id, created_at").first
  end
end
