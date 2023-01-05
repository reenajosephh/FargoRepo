global class InteractionBatchSchedular implements Schedulable {
   global void execute(SchedulableContext sc) {
      InteractionBatch batchJob = new InteractionBatch();
      Database.executeBatch(batchJob);
   }
}