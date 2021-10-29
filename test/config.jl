using Cambrian

@testset "Configuration parsing" begin
    cfg_filename = string(@__DIR__, "/../cfg/oneplus.yaml")
    cfg = get_config(cfg_filename)

    @test cfg.n_population == 5
    @test cfg.d_fitness == 1
    @test cfg.save_gen == 0
    @test cfg.n_genes == 10
    @test cfg.n_gen == 10
    @test cfg.seed == 0
    @test cfg.m_rate == 0.3
    @test cfg.n_elite == 1
    @test cfg.log_gen == 0
    @test haskey(cfg, :id)

    default_id = cfg.id
    my_custom_id = "custom_id"
    my_custom_arg = 0x01
    cfg = get_config(cfg_filename, custom_arg=0x01, id=my_custom_id)
    @test cfg.id == my_custom_id
    @test cfg.id != default_id
    @test haskey(cfg, :custom_arg)
    @test cfg.custom_arg == my_custom_arg
end
