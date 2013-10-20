module HeiaHeia
  class Client

    # Methods for the TrainingLog API
    module TrainingLog

      # Get a single training log
      #
      # @param id [Integer] A ID of training log
      # @return [Sawyer::Resource] A hash representing the training log
      def training_log(id)
        get "training_logs/#{id}"
      end

      # List comments for a single training log
      #
      # @param id [Integer] A ID of training log
      # @return [Array] An array of hashes representing comments
      def training_log_comments(id)
        get "training_logs/#{id}comments"
      end

      # Create a training log
      #
      # @param sport_id [Integer] A ID of HeiaHeia sport
      # @param date [Date] A date in ISO 8601 format
      # @return [Sawyer::Resource] A hash representing the new training log
      # @example Create a commit
      #   commit = HeiaHeia.create_training_log(2, '2013-10-20',
      #                                         { status: 'regular',
      #                                           notes: 'Informal notes for the entry' })
      #   commit.id # => "16254409537713"
      #   commit.sport.name # => "Running"
      #   commit.notes # => "Informal notes for the entry"
      #   commit.user # => { "first_name" => "Alan", "last_name" => "Turing", ... }
      def create_training_log(sport_id, date, options = {})
        params = { sport_id: sport_id, date: date }
        post "training_logs", options.merge(params)
      end

      # Update a training log
      #
      # @param id [Integer] A ID of training log
      # @return [Sawyer::Resource] A hash representing the training log
      def update_training_log(id, options = {})
        put "training_logs", options
      end

      # Delete a training log
      #
      # @param sport_id [Integer] A ID of HeiaHeia sport
      # @return [nil] nil
      def delete_commit_comment(id)
        boolean_from_response :delete, "training_logs/#{id}"
      end

    end
  end
end
