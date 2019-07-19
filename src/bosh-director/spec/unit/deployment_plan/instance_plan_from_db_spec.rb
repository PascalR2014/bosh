module Bosh::Director
  module DeploymentPlan
    describe InstancePlanFromDB do
      let(:instance_model) { Models::Instance.make }

      let(:cloud_config_manifest) { Bosh::Spec::NewDeployments.simple_cloud_config }

      let(:deployment_manifest) { Bosh::Spec::NewDeployments.simple_manifest_with_instance_groups }
      let(:deployment_model) do
        cloud_config = BD::Models::Config.make(:cloud, content: YAML.dump(cloud_config_manifest))
        deployment = BD::Models::Deployment.make(
          name: deployment_manifest['name'],
          manifest: YAML.dump(deployment_manifest),
        )
        deployment.cloud_configs = [cloud_config]
        deployment
      end
      let(:deployment_plan) do
        planner_factory = PlannerFactory.create(logger)
        planner_factory.create_from_model(deployment_model)
      end


      describe '.create_from_instance_model' do
        it 'can create an instance plan from the instance model' do
          instance_plan_from_db = InstancePlanFromDB.create_from_instance_model(
            instance_model,
            deployment_model,
            'started',
            logger,
          )
          expect(instance_plan_from_db.instance_model).to eq(instance_model)
        end
      end
    end
  end
end
